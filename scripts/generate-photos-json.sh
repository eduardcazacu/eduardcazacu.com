#!/usr/bin/env sh
set -eu

PHOTOS_DIR="${1:-photos}"
OUT_FILE="${2:-photos.json}"

if [ ! -d "$PHOTOS_DIR" ]; then
  echo "photos directory not found: $PHOTOS_DIR" >&2
  exit 1
fi

# Build JSON array of relative photo paths (stable order).
find "$PHOTOS_DIR" -maxdepth 1 -type f \
  \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.avif' -o -iname '*.gif' \) \
  | LC_ALL=C sort -V \
  | awk '
      BEGIN { printf("[") }
      {
        file=$0
        sub(/^\.\//, "", file)
        gsub(/\\/, "\\\\", file)
        gsub(/"/, "\\\"", file)
        if (NR > 1) printf(",")
        printf("\"./%s\"", file)
      }
      END { printf("]\n") }
    ' > "$OUT_FILE"

echo "Wrote $OUT_FILE"
