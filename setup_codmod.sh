#!/bin/bash

# This script installs the codmod tool.
echo "Installing codmod..."

version=$(curl -s https://codmod-release.storage.googleapis.com/latest)
curl -O "https://codmod-release.storage.googleapis.com/${version}/linux/amd64/codmod"
chmod +x codmod

echo "codmod installed successfully."
echo "Please add the executable to your PATH or create an alias."
