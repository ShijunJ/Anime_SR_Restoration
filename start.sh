#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Create a new Conda environment named ASRR with Python 3.10
echo "Creating a new Conda environment named ASRR with Python 3.10..."
conda create -n ASRR python=3.10 -y

# Activate the newly created Conda environment
echo "Activating the ASRR environment..."
source activate ASRR

# Install PyTorch, torchvision, and torchaudio
echo "Installing PyTorch, torchvision, and torchaudio..."
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# Install other required packages from requirements.txt
echo "Installing packages from requirements.txt..."
pip install -r requirements.txt

echo "Environment setup is complete."
