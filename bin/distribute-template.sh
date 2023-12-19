#/usr/bin/env bash

TEMPLATE_PATH=$1
TARGET_DIR=$(dirname "$TEMPLATE_PATH" | sed 's/^[^\/]*\///')

mkdir -p "$TARGET_DIR"
cp "../$TEMPLATE_PATH" "$TARGET_DIR/"