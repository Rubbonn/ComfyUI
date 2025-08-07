FROM debian:latest

RUN apt-get update && apt-get install -y python3 python3-pip python3-venv wget curl git
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb \
    && apt-get install -y ./cuda-keyring_1.1-1_all.deb \
    && rm cuda-keyring_1.1-1_all.deb \
    && apt-get update \
    && apt-get install -y cuda-nvcc-12-9 libcusparse-dev-12-9 libcublas-dev-12-9 libcusolver-dev-12-9 \
    && apt-get clean
RUN mkdir -m 777 /.triton /.cache

WORKDIR /app
COPY . /app

ENTRYPOINT ["./entrypoint.sh", "--listen", "--disable-auto-launch"]
VOLUME ["/app"]
EXPOSE 8188
