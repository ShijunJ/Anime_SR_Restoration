# Use continuumio/anaconda3 as base image
FROM continuumio/anaconda3:main

COPY . .

# Create conda env
RUN conda create -n ASRR python=3.10 -y

# execute following commands under conda env instead of default shell env
SHELL ["conda", "run", "-n", "ASRR", "/bin/bash", "-c"]

RUN chmod 1777 /tmp

RUN apt-get update && apt-get install -y libgl1-mesa-glx

# 安装依赖和工具
RUN apt-get update && apt-get install -y wget gnupg software-properties-common

# 添加 NVIDIA GPG key
RUN apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub

# 添加 CUDA 存储库
RUN add-apt-repository "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /"
RUN add-apt-repository "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/ /"

# 安装 CUDA 和 cuDNN
RUN apt-get update && apt-get install -y cuda cudnn

# 安装 libgl1-mesa-glx
RUN apt-get install -y libgl1-mesa-glx

# 设置环境变量
ENV PATH /usr/local/cuda/bin:$PATH
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64:$LD_LIBRARY_PATH


# Install Pytorch we use:
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# Install Other packages:
RUN pip install -r requirements.txt

RUN echo "ALL parts finished!"

CMD ["conda", "run", "-n", "ASRR", "python", "inference.py"]

