import 'dart:math' as math;
import 'dart:ui';

typedef RidePreset = ({String label, Offset point});

enum MapPlaceKind { tower, mall, shop, house, park }

class MapPlace {
  final double x;
  final double y;
  final double w;
  final double h;
  final MapPlaceKind kind;
  final String? label;
  final Offset? curb;

  const MapPlace({
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    required this.kind,
    this.label,
    this.curb,
  });

  bool contains(Offset p, {double margin = 0.012}) {
    return p.dx >= x - margin &&
        p.dx <= x + w + margin &&
        p.dy >= y - margin &&
        p.dy <= y + h + margin;
  }
}

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
  static const defaultPickupLabel = 'Main Blvd';

  static const presets = <RidePreset>[
    (label: 'Liberty Sq', point: Offset(0.486, 0.45)),
    (label: 'Gulberg III', point: Offset(0.25, 0.299)),
    (label: 'DHA Phase 5', point: Offset(0.158, 0.545)),
  ];

  /// Architectural footprints painted on the map; named entries are directly tappable.
  static const places = <MapPlace>[
    MapPlace(
      x: 0.195,
      y: 0.18,
      w: 0.23,
      h: 0.08,
      kind: MapPlaceKind.tower,
      label: 'Siddiq Trade',
      curb: Offset(0.31, 0.296),
    ),
    MapPlace(
      x: 0.52,
      y: 0.175,
      w: 0.205,
      h: 0.08,
      kind: MapPlaceKind.tower,
      label: 'Vogue Towers',
      curb: Offset(0.62, 0.285),
    ),
    MapPlace(
      x: 0.20,
      y: 0.33,
      w: 0.24,
      h: 0.088,
      kind: MapPlaceKind.park,
      label: 'Gulberg Park',
      curb: Offset(0.32, 0.45),
    ),
    MapPlace(
      x: 0.515,
      y: 0.312,
      w: 0.185,
      h: 0.056,
      kind: MapPlaceKind.mall,
      label: 'Liberty Hub',
      curb: Offset(0.60, 0.286),
    ),
    MapPlace(
      x: 0.81,
      y: 0.305,
      w: 0.17,
      h: 0.08,
      kind: MapPlaceKind.shop,
      label: 'Hafeez Mart',
      curb: Offset(0.765, 0.34),
    ),
    MapPlace(
      x: 0.20,
      y: 0.48,
      w: 0.185,
      h: 0.075,
      kind: MapPlaceKind.mall,
      label: 'Al-Fatah',
      curb: Offset(0.28, 0.45),
    ),
    MapPlace(
      x: 0.555,
      y: 0.472,
      w: 0.18,
      h: 0.058,
      kind: MapPlaceKind.shop,
      label: 'Second Cup',
      curb: Offset(0.65, 0.443),
    ),
    MapPlace(
      x: 0.545,
      y: 0.585,
      w: 0.20,
      h: 0.085,
      kind: MapPlaceKind.house,
      label: 'Model House',
      curb: Offset(0.64, 0.565),
    ),
    MapPlace(
      x: 0.21,
      y: 0.63,
      w: 0.23,
      h: 0.085,
      kind: MapPlaceKind.house,
      label: 'Cavalry Villa',
      curb: Offset(0.34, 0.59),
    ),
    // Supporting neighborhood houses & shops for dense city framing
    MapPlace(x: 0.015, y: 0.325, w: 0.10, h: 0.082, kind: MapPlaceKind.house),
    MapPlace(x: 0.015, y: 0.475, w: 0.105, h: 0.082, kind: MapPlaceKind.shop),
    MapPlace(x: 0.825, y: 0.18, w: 0.14, h: 0.07, kind: MapPlaceKind.shop),
    MapPlace(x: 0.815, y: 0.46, w: 0.15, h: 0.072, kind: MapPlaceKind.house),
  ];

  // Portrait-weighted aspect factor so vertical segments match visual street distance.
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
    (1, 2, 'North Blvd'),
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
    (2, 11, 'Main Blvd'),
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

  /// Snaps a map tap to a tapped landmark curb or nearest street segment.
  static ({Offset point, String label}) snapToRoad(Offset tap) {
    for (final place in places) {
      if (place.label != null &&
          place.curb != null &&
          place.contains(tap)) {
        return (point: place.curb!, label: place.label!);
      }
    }
    final hit = _nearestEdge(tap);
    return (point: hit.point, label: hit.label);
  }

  /// Picks a nearby driver hub and plans a street-aligned approach route to [pickup].
  static RideRoutePlan planDriverApproach(Offset pickup) {
    Offset? chosenHub;
    var bestHubDist = double.infinity;
    var farthestHub = _driverHubs.first;
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

  /// Plans a continuing street path for the driver's car to depart after drop-off.
  static List<Offset> planDepartureRoute(
    Offset destination,
    List<Offset> tripPoints,
  ) {
    final hit = _nearestEdge(destination);
    final (u, v, _) = _edges[hit.index];
    final prevPt = tripPoints.length >= 2
        ? tripPoints[tripPoints.length - 2]
        : _nodes[u];
    final incomingDir = _weightedUnit(destination - prevPt);

    final toU = _weightedUnit(_nodes[u] - destination);
    final toV = _weightedUnit(_nodes[v] - destination);
    final dotU = _weightedDot(incomingDir, toU);
    final dotV = _weightedDot(incomingDir, toV);

    var prevIdx = dotV >= dotU ? u : v;
    var currIdx = dotV >= dotU ? v : u;
    final path = <Offset>[destination];

    for (var hop = 0; hop < 2; hop++) {
      final currPt = _nodes[currIdx];
      if ((currPt - path.last).distance > 0.015) {
        path.add(currPt);
      }

      final heading = _weightedUnit(currPt - path[path.length - 2]);
      int? nextIdx;
      var bestDot = 0.25;
      for (final (a, b, _) in _edges) {
        final cand = a == currIdx ? b : (b == currIdx ? a : -1);
        if (cand == -1 || cand == prevIdx) continue;
        final d = _weightedDot(heading, _weightedUnit(_nodes[cand] - currPt));
        if (d > bestDot) {
          bestDot = d;
          nextIdx = cand;
        }
      }
      if (nextIdx == null) break;
      prevIdx = currIdx;
      currIdx = nextIdx;
    }

    final anchor = path.length >= 2 ? path[path.length - 2] : prevPt;
    final tailDir = path.last - anchor;
    final len = tailDir.distance;
    if (len > 0) {
      path.add(path.last + (tailDir / len) * 0.22);
    }
    return _dedupePoints(path);
  }

  static Offset _weightedUnit(Offset v) {
    final len = math.sqrt(
      v.dx * v.dx + (v.dy * _verticalWeight) * (v.dy * _verticalWeight),
    );
    return len == 0 ? const Offset(1, 0) : v / len;
  }

  static double _weightedDot(Offset a, Offset b) {
    return a.dx * b.dx + (a.dy * _verticalWeight) * (b.dy * _verticalWeight);
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
    final startEdge = _nearestEdge(start).index;
    final endEdge = _nearestEdge(end).index;

    if (startEdge == endEdge) {
      return _dedupePoints([start, end]);
    }

    final nodeCount = _nodes.length;
    final startIdx = nodeCount;
    final endIdx = nodeCount + 1;
    final totalCount = nodeCount + 2;
    final adj = List.generate(
      totalCount,
      (_) => <(int, double)>[],
      growable: false,
    );

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

  static ({int index, Offset point, String label}) _nearestEdge(Offset p) {
    var bestIdx = 0;
    var bestDist = double.infinity;
    var bestPoint = p;
    var bestLabel = 'Canal Bank Rd';

    for (var i = 0; i < _edges.length; i++) {
      final (u, v, label) = _edges[i];
      final proj = _projectOnSegment(p, _nodes[u], _nodes[v]);
      final d = _weightedDistance(p, proj);
      if (d < bestDist) {
        bestDist = d;
        bestIdx = i;
        bestPoint = proj;
        bestLabel = label;
      }
    }

    return (index: bestIdx, point: bestPoint, label: bestLabel);
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
