#!/bin/bash

set -e

echo "=========================================="
echo "Installing dependencies..."
echo "=========================================="
pip install --upgrade pip
pip install .[docs]

echo ""
echo "=========================================="
echo "Validating documentation..."
echo "=========================================="
mkdocs build --strict

echo ""
echo "=========================================="
echo "Documentation validation complete!"
echo "=========================================="
