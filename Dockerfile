# Use continuumio/anaconda3 as base image
FROM continuumio/anaconda3:main

COPY . .

# Create conda env
RUN conda create -n ASRR python=3.10 -y

# execute following commands under conda env instead of default shell env
SHELL ["conda", "run", "-n", "ASRR", "/bin/bash", "-c"]

RUN chmod 1777 /tmp

RUN apt-get update && apt-get install -y libgl1-mesa-glx

# Install Pytorch we use:
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# Install Other packages:
# RUN pip install -r requirements.txt

RUN echo "ALL parts finished!"
