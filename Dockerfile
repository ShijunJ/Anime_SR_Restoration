# Use cuda as base image
FROM nvidia/cuda:11.0.3-runtime-ubuntu20.04

# Install wget and other system tools
RUN apt-get update && apt-get install -y wget

# RUN apt-get update && apt-get install -y libgl1-mesa-glx

# Download and install Anaconda
RUN wget https://repo.anaconda.com/archive/Anaconda3-2020.07-Linux-x86_64.sh -O /tmp/anaconda.sh \
    && /bin/bash /tmp/anaconda.sh -b -p /opt/conda \
    && rm /tmp/anaconda.sh

# Add conda command into variable PATH
ENV PATH /opt/conda/bin:$PATH

# Create conda env
RUN conda create -n ASRR python=3.10 -y

# execute following commands under conda env instead of default shell env
SHELL ["conda", "run", "-n", "ASRR", "/bin/bash", "-c"]




RUN chmod 1777 /tmp

# 安装 libgl1-mesa-glx
RUN apt-get install -y libgl1-mesa-glx
RUN apt-get update && apt-get install -y libglib2.0-0

COPY . .

# Install Pytorch we use:
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

RUN pip install -r requirements.txt

RUN echo "ALL parts finished!"

# CMD ["conda", "run", "-n", "ASRR", "python", "inference.py"]