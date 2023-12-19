#/usr/bin/env bash
set -eo pipefail

if [ -z "$1" ]; then
    echo "Please provide TEMPLATE_PATH."
    exit 1
fi

TEMPLATE_PATH=$1

# Check if TEMPLATE_PATH is a file and exists
if [ ! -f "../$TEMPLATE_PATH" ]; then
    echo "Error: ../$TEMPLATE_PATH is not a valid file or does not exist."
    exit 1
fi

TARGET_DIR=$(dirname "$TEMPLATE_PATH" | sed 's/^[^\/]*\///')

mkdir -p "$TARGET_DIR"
cp "../$TEMPLATE_PATH" "$TARGET_DIR/"
echo "Copied file $TEMPLATE_PATH to $TARGET_DIR"
