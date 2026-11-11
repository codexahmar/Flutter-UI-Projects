import struct
import zlib
import math
import os
import binascii

def paeth_predictor(a, b, c):
    p = a + b - c
    pa = abs(p - a)
    pb = abs(p - b)
    pc = abs(p - c)
    if pa <= pb and pa <= pc:
        return a
    elif pb <= pc:
        return b
    else:
        return c

def decode_png_rgb(path):
    with open(path, 'rb') as f:
        data = f.read()

    assert data[:8] == b'\x89PNG\r\n\x1a\n'
    offset = 8
    width = height = None
    idat_data = bytearray()

    while offset < len(data):
        length = struct.unpack('>I', data[offset:offset+4])[0]
        chunk_type = data[offset+4:offset+8]
        chunk_data = data[offset+8:offset+8+length]
        offset += 8 + length + 4

        if chunk_type == b'IHDR':
            width, height, bit_depth, color_type = struct.unpack('>IIBB', chunk_data[:10])
            assert bit_depth == 8 and color_type == 2
        elif chunk_type == b'IDAT':
            idat_data.extend(chunk_data)
        elif chunk_type == b'IEND':
            break

    raw = zlib.decompress(bytes(idat_data))
    bpp = 3
    stride = width * bpp
    recon = bytearray(width * height * bpp)

    raw_offset = 0
    recon_offset = 0
    prior_row = bytearray(stride)

    for y in range(height):
        filter_type = raw[raw_offset]
        raw_offset += 1
        curr_row = bytearray(stride)

        for x in range(stride):
            filt_val = raw[raw_offset + x]
            recon_a = curr_row[x - bpp] if x >= bpp else 0
            recon_b = prior_row[x]
            recon_c = prior_row[x - bpp] if x >= bpp else 0

            if filter_type == 0:
                val = filt_val
            elif filter_type == 1:
                val = (filt_val + recon_a) & 0xFF
            elif filter_type == 2:
                val = (filt_val + recon_b) & 0xFF
            elif filter_type == 3:
                val = (filt_val + ((recon_a + recon_b) >> 1)) & 0xFF
            elif filter_type == 4:
                val = (filt_val + paeth_predictor(recon_a, recon_b, recon_c)) & 0xFF
            else:
                raise ValueError(f"Unknown filter: {filter_type}")
            curr_row[x] = val

        recon[recon_offset:recon_offset+stride] = curr_row
        prior_row = curr_row
        recon_offset += stride
        raw_offset += stride

    return width, height, recon

def make_chunk(chunk_type, chunk_data):
    length = len(chunk_data)
    crc = binascii.crc32(chunk_type + chunk_data) & 0xffffffff
    return struct.pack('>I', length) + chunk_type + chunk_data + struct.pack('>I', crc)

def write_png_rgba(out_path, width, height, rgba_data):
    # PNG signature
    header = b'\x89PNG\r\n\x1a\n'
    # IHDR: width, height, bit_depth=8, color_type=6 (RGBA), comp=0, filt=0, interlace=0
    ihdr_data = struct.pack('>IIBBBBB', width, height, 8, 6, 0, 0, 0)
    ihdr_chunk = make_chunk(b'IHDR', ihdr_data)

    # Raw scanlines with filter type 0 (None)
    stride = width * 4
    scanlines = bytearray()
    for y in range(height):
        scanlines.append(0) # filter type None
        row = rgba_data[y * stride : (y + 1) * stride]
        scanlines.extend(row)

    compressed = zlib.compress(bytes(scanlines), 9)
    idat_chunk = make_chunk(b'IDAT', compressed)
    iend_chunk = make_chunk(b'IEND', b'')

    with open(out_path, 'wb') as f:
        f.write(header + ihdr_chunk + idat_chunk + iend_chunk)
    print(f"Successfully wrote {width}x{height} transparent RGBA PNG to {out_path}")

def process_pinterest_logo(src_path, dst_path):
    w, h, rgb = decode_png_rgb(src_path)
    cx, cy = 370.0, 370.0
    radius = 260.0

    # Crop bounds tightly to circle with 2px anti-aliased padding
    pad = 2
    x0 = int(cx - radius - pad)
    y0 = int(cy - radius - pad)
    x1 = int(cx + radius + pad)
    y1 = int(cy + radius + pad)
    out_w = x1 - x0
    out_h = y1 - y0

    rgba = bytearray(out_w * out_h * 4)

    for out_y in range(out_h):
        in_y = y0 + out_y
        for out_x in range(out_w):
            in_x = x0 + out_x
            dx = in_x + 0.5 - cx
            dy = in_y + 0.5 - cy
            dist = math.sqrt(dx * dx + dy * dy)

            out_idx = (out_y * out_w + out_x) * 4
            in_idx = (in_y * w + in_x) * 3

            r_val = rgb[in_idx]
            g_val = rgb[in_idx + 1]
            b_val = rgb[in_idx + 2]

            if dist <= radius - 0.75:
                # Inside circle: 100% opaque
                rgba[out_idx] = r_val
                rgba[out_idx + 1] = g_val
                rgba[out_idx + 2] = b_val
                rgba[out_idx + 3] = 255
            elif dist >= radius + 1.25:
                # Completely outside circle: 100% transparent
                rgba[out_idx] = 0
                rgba[out_idx + 1] = 0
                rgba[out_idx + 2] = 0
                rgba[out_idx + 3] = 0
            else:
                # Anti-aliased outer edge
                # Smooth cubic / Hermite interpolation
                t = (radius + 1.25 - dist) / 2.0
                t = max(0.0, min(1.0, t))
                alpha = int(255 * (t * t * (3 - 2 * t)))
                
                # Use clean Pinterest red for boundary pixels to prevent checkerboard fringe
                rgba[out_idx] = 230 # Authentic Pinterest Red
                rgba[out_idx + 1] = 0
                rgba[out_idx + 2] = 35
                rgba[out_idx + 3] = alpha

    write_png_rgba(dst_path, out_w, out_h, rgba)

if __name__ == '__main__':
    src = 'assets/images/pinterest-logo.png'
    # Backup original just in case
    backup = 'assets/images/pinterest-logo-orig.png'
    if not os.path.exists(backup):
        import shutil
        shutil.copyfile(src, backup)
    process_pinterest_logo(backup, src)
