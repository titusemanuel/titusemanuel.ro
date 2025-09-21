#!/bin/bash
set -e

INPUT_DIR="images"
OUTPUT_DIR="images/optimized"

mkdir -p "$OUTPUT_DIR"

for img in "$INPUT_DIR"/*.{jpg,jpeg,png}; do
    [ -e "$img" ] || continue  # dacă nu există fișiere, sare peste

    filename=$(basename "$img")
    name="${filename%.*}"

    echo ">> Procesez $filename"

    # Resize în mai multe dimensiuni + optimizare JPG
    convert "$img" -resize 320x -strip -quality 75 "$OUTPUT_DIR/${name}-320.jpg"
    convert "$img" -resize 640x -strip -quality 78 "$OUTPUT_DIR/${name}-640.jpg"
    convert "$img" -resize 1200x -strip -quality 82 "$OUTPUT_DIR/${name}-1200.jpg"

    # Conversie în WebP (cu cwebp, dacă există)
    if command -v cwebp &> /dev/null; then
        cwebp -q 80 "$OUTPUT_DIR/${name}-320.jpg" -o "$OUTPUT_DIR/${name}-320.webp"
        cwebp -q 80 "$OUTPUT_DIR/${name}-640.jpg" -o "$OUTPUT_DIR/${name}-640.webp"
        cwebp -q 80 "$OUTPUT_DIR/${name}-1200.jpg" -o "$OUTPUT_DIR/${name}-1200.webp"
    else
        # fallback la ImageMagick
        convert "$OUTPUT_DIR/${name}-320.jpg" "$OUTPUT_DIR/${name}-320.webp"
        convert "$OUTPUT_DIR/${name}-640.jpg" "$OUTPUT_DIR/${name}-640.webp"
        convert "$OUTPUT_DIR/${name}-1200.jpg" "$OUTPUT_DIR/${name}-1200.webp"
    fi
done

echo "✅ Toate imaginile au fost optimizate în $OUTPUT_DIR/"

