FROM python:3.9-slim

ENV DEBIAN_FRONTEND noninteractive

# RUN rm /etc/apt/sources.list.d/cuda.list || true && \
#     rm /etc/apt/sources.list.d/nvidia-ml.list || true && \
#     apt-key del 7fa2af80  && \
#     apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub && \
#     apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
RUN apt update && \
    apt install --no-install-recommends -y wget build-essential gcc && \
    apt clean && rm -rf /var/lib/apt/lists/* && \
    curl https://bootstrap.pypa.io/get-pip.py | python3.9

# RUN apt update -y && \
#     apt upgrade -y && \
#     apt install -y curl wget software-properties-common && \
#     add-apt-repository ppa:deadsnakes/ppa && \
#     apt install -y python3.9 python3.9-distutils && \
#     curl https://bootstrap.pypa.io/get-pip.py | python3.9

WORKDIR /rembg

COPY . .
RUN python3.9 -m pip install .[gpu]

RUN mkdir -p ~/.u2net && \
    wget https://github.com/danielgatis/rembg/releases/download/v0.0.0/u2netp.onnx -O ~/.u2net/u2netp.onnx
# RUN wget https://github.com/danielgatis/rembg/releases/download/v0.0.0/u2net.onnx -O ~/.u2net/u2net.onnx
# RUN wget https://github.com/danielgatis/rembg/releases/download/v0.0.0/u2net_human_seg.onnx -O ~/.u2net/u2net_human_seg.onnx
# RUN wget https://github.com/danielgatis/rembg/releases/download/v0.0.0/u2net_cloth_seg.onnx -O ~/.u2net/u2net_cloth_seg.onnx

EXPOSE 5000
ENTRYPOINT ["rembg"]
CMD ["--help"]
