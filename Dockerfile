FROM debian:latest

RUN apt-get update && apt-get install -y python3 python3-pip python3-venv wget curl git && apt-get clean

WORKDIR /app
COPY . /app

ENTRYPOINT ["./entrypoint.sh", "--listen", "--disable-auto-launch"]
VOLUME ["/app"]
EXPOSE 8188
