#!/bin/bash

set -e

echo "=========================================="
echo "Installing dependencies..."
echo "=========================================="
pip install --upgrade pip
pip install .[dev]

echo ""
echo "=========================================="
echo "Running Black (code formatter)..."
echo "=========================================="
black src/redis_memory/

echo ""
echo "=========================================="
echo "Running docformatter (docstring formatter)..."
echo "=========================================="
docformatter \
  --in-place \
  --recursive \
  --wrap-summaries 72 \
  --wrap-descriptions 72 \
  src/redis_memory/

echo ""
echo "=========================================="
echo "Running isort (import sorter)..."
echo "=========================================="
isort src/redis_memory/

echo ""
echo "=========================================="
echo "Formatting complete!"
echo "=========================================="
