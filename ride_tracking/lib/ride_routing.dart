import 'dart:math' as math;
import 'dart:ui';

typedef RidePreset = ({String label, Offset point});

typedef SnappedStop = ({Offset point, String label});

class RideRoutePlan {
  final List<Offset> points;
  final double distanceKm;
  final int farePkr;
  final int etaMinutes;

  const RideRoutePlan({
    required this.points,
    required this.distanceKm,
    required this.farePkr,
    required this.etaMinutes,
  });
}

abstract final class RideRouting {
  static const defaultPickup = Offset(0.77, 0.28);
  static const defaultPickupLabel = 'MM Alam Rd';

  static const presets = <RidePreset>[
    (label: 'Liberty Sq', point: Offset(0.486, 0.45)),
    (label: 'Gulberg III', point: Offset(0.25, 0.299)),
    (label: 'DHA Phase 5', point: Offset(0.158, 0.545)),
  ];

  // Portrait-weighted aspect factor so vertical road segments reflect real visual length.
  static const _verticalWeight = 1.65;

  static const _nodes = <Offset>[
    Offset(0.151, 0.303), // 0: nWest
    Offset(0.474, 0.291), // 1: nMid
    Offset(0.77, 0.28), // 2: nMain (default pickup)
    Offset(0.155, 0.45), // 3: mWest
    Offset(0.486, 0.45), // 4: mCenter (Liberty Sq)
    Offset(0.56, 0.45), // 5: mMm
    Offset(0.767, 0.437), // 6: mMain
    Offset(0.16, 0.61), // 7: sWest
    Offset(0.34, 0.59), // 8: sMm
    Offset(0.494, 0.577), // 9: sCenter
    Offset(0.775, 0.553), // 10: sMain
    Offset(0.76, 0.34), // 11: dMain (MM Alam Rd x Main Blvd)
    Offset(0.148, 0.22), // 12: nWestTop
    Offset(0.469, 0.22), // 13: nMidTop
    Offset(0.76, 0.22), // 14: nMainTop
    Offset(0.10, 0.304), // 15: wNorthEnd
    Offset(0.90, 0.271), // 16: eNorthEnd
    Offset(0.10, 0.45), // 17: wMidEnd
    Offset(0.90, 0.429), // 18: eMidEnd
  ];

  static const _edges = <(int, int, String)>[
    // Horizontal corridors
    (15, 0, 'Gulberg III'),
    (0, 1, 'Gulberg III'),
    (1, 2, 'MM Alam Rd'),
    (2, 16, 'Main Blvd'),
    (17, 3, 'Canal Bank Rd'),
    (3, 4, 'Canal Bank Rd'),
    (4, 5, 'Liberty Sq'),
    (5, 6, 'Canal Bank Rd'),
    (6, 18, 'Canal Bank Rd'),
    (7, 8, 'Canal Bank Rd'),
    (8, 9, 'Canal Bank Rd'),
    (9, 10, 'Canal Bank Rd'),
    // Vertical avenues
    (12, 0, 'West Ave'),
    (0, 3, 'West Ave'),
    (3, 7, 'West Ave'),
    (13, 1, 'Liberty Rd'),
    (1, 4, 'Liberty Rd'),
    (4, 9, 'Liberty Rd'),
    (14, 2, 'Main Blvd'),
    (2, 11, 'MM Alam Rd'),
    (11, 6, 'Main Blvd'),
    (6, 10, 'Main Blvd'),
    // MM Alam Rd diagonal
    (7, 8, 'MM Alam Rd'),
    (8, 5, 'MM Alam Rd'),
    (5, 11, 'MM Alam Rd'),
  ];

  static const _driverHubs = <Offset>[
    Offset(0.16, 0.61), // South-West (West Ave & MM Alam)
    Offset(0.775, 0.553), // South-East (Main Blvd)
    Offset(0.151, 0.303), // North-West (Gulberg)
  ];

  /// Snaps a normalized map tap onto the nearest street segment and returns its label.
  static SnappedStop snapToRoad(Offset tap) {
    var bestDist = double.infinity;
    var bestPoint = tap;
    var bestLabel = 'Canal Bank Rd';

    for (final (u, v, label) in _edges) {
      final projected = _projectOnSegment(tap, _nodes[u], _nodes[v]);
      final dist = _weightedDistance(tap, projected);
      if (dist < bestDist) {
        bestDist = dist;
        bestPoint = projected;
        bestLabel = label;
      }
    }

    return (point: bestPoint, label: bestLabel);
  }

  /// Picks a realistic nearby driver spawn point and plans the road route to [pickup].
  static RideRoutePlan planDriverApproach(Offset pickup) {
    Offset? chosenHub;
    var bestHubDist = double.infinity;
    Offset farthestHub = _driverHubs.first;
    var maxDist = -1.0;

    for (final hub in _driverHubs) {
      final d = _weightedDistance(hub, pickup);
      if (d > maxDist) {
        maxDist = d;
        farthestHub = hub;
      }
      if (d >= 0.38 && d < bestHubDist) {
        bestHubDist = d;
        chosenHub = hub;
      }
    }

    return planRoute(chosenHub ?? farthestHub, pickup, isApproach: true);
  }

  /// Computes a street-aligned shortest path, distance in km, ETA, and fare from [from] to [to].
  static RideRoutePlan planRoute(
    Offset from,
    Offset to, {
    bool isApproach = false,
  }) {
    final points = _shortestRoadPath(from, to);
    var weightedLen = 0.0;
    for (var i = 1; i < points.length; i++) {
      weightedLen += _weightedDistance(points[i - 1], points[i]);
    }

    final distanceKm = double.parse(
      (weightedLen * 7.2).clamp(0.7, 14.0).toStringAsFixed(1),
    );
    final rawFare = 160 + distanceKm * 65;
    final farePkr = ((rawFare / 10).round() * 10).clamp(180, 1500);
    final etaMinutes = isApproach
        ? (distanceKm * 0.9).ceil().clamp(2, 6)
        : (distanceKm * 1.5).ceil().clamp(3, 18);

    return RideRoutePlan(
      points: points,
      distanceKm: distanceKm,
      farePkr: farePkr,
      etaMinutes: etaMinutes,
    );
  }

  static List<Offset> _shortestRoadPath(Offset start, Offset end) {
    final startEdge = _closestEdgeIndex(start);
    final endEdge = _closestEdgeIndex(end);

    if (startEdge == endEdge) {
      return _dedupePoints([start, end]);
    }

    final nodeCount = _nodes.length;
    final startIdx = nodeCount;
    final endIdx = nodeCount + 1;
    final totalCount = nodeCount + 2;

    final adj = List.generate(totalCount, (_) => <(int, double)>[], growable: false);

    void connect(int a, int b, double w) {
      adj[a].add((b, w));
      adj[b].add((a, w));
    }

    for (final (u, v, _) in _edges) {
      connect(u, v, _weightedDistance(_nodes[u], _nodes[v]));
    }

    final (su, sv, _) = _edges[startEdge];
    connect(startIdx, su, _weightedDistance(start, _nodes[su]));
    connect(startIdx, sv, _weightedDistance(start, _nodes[sv]));

    final (eu, ev, _) = _edges[endEdge];
    connect(endIdx, eu, _weightedDistance(end, _nodes[eu]));
    connect(endIdx, ev, _weightedDistance(end, _nodes[ev]));

    final dist = List<double>.filled(totalCount, double.infinity);
    final prev = List<int>.filled(totalCount, -1);
    final visited = List<bool>.filled(totalCount, false);
    dist[startIdx] = 0;

    for (var step = 0; step < totalCount; step++) {
      var u = -1;
      for (var i = 0; i < totalCount; i++) {
        if (!visited[i] && (u == -1 || dist[i] < dist[u])) {
          u = i;
        }
      }
      if (u == -1 || dist[u] == double.infinity || u == endIdx) break;
      visited[u] = true;

      for (final (v, w) in adj[u]) {
        final cand = dist[u] + w;
        if (cand < dist[v]) {
          dist[v] = cand;
          prev[v] = u;
        }
      }
    }

    final chain = <Offset>[];
    var cur = endIdx;
    while (cur != -1) {
      if (cur == endIdx) {
        chain.add(end);
      } else if (cur == startIdx) {
        chain.add(start);
      } else {
        chain.add(_nodes[cur]);
      }
      cur = prev[cur];
    }

    return _dedupePoints(chain.reversed.toList());
  }

  static int _closestEdgeIndex(Offset p) {
    var bestIdx = 0;
    var bestDist = double.infinity;
    for (var i = 0; i < _edges.length; i++) {
      final (u, v, _) = _edges[i];
      final proj = _projectOnSegment(p, _nodes[u], _nodes[v]);
      final d = _weightedDistance(p, proj);
      if (d < bestDist) {
        bestDist = d;
        bestIdx = i;
      }
    }
    return bestIdx;
  }

  static Offset _projectOnSegment(Offset p, Offset a, Offset b) {
    final ab = b - a;
    final lenSq = ab.dx * ab.dx + ab.dy * ab.dy;
    if (lenSq == 0) return a;
    final t = (((p.dx - a.dx) * ab.dx + (p.dy - a.dy) * ab.dy) / lenSq).clamp(
      0.0,
      1.0,
    );
    return Offset(a.dx + ab.dx * t, a.dy + ab.dy * t);
  }

  static double _weightedDistance(Offset a, Offset b) {
    final dx = b.dx - a.dx;
    final dy = (b.dy - a.dy) * _verticalWeight;
    return math.sqrt(dx * dx + dy * dy);
  }

  static List<Offset> _dedupePoints(List<Offset> raw) {
    if (raw.length <= 2) return raw;
    final out = <Offset>[raw.first];
    for (var i = 1; i < raw.length - 1; i++) {
      if ((raw[i] - out.last).distance > 0.015) {
        out.add(raw[i]);
      }
    }
    if ((raw.last - out.last).distance > 0.015) {
      out.add(raw.last);
    } else if (out.length > 1) {
      out[out.length - 1] = raw.last;
    }
    return out;
  }
}

