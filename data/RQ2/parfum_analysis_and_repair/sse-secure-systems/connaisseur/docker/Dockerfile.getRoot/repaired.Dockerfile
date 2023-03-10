FROM python:3-slim
# Based on debian as alpine needs compilation of cryptography package, which bloats image and increases build time immensely

WORKDIR /app

COPY requirements.txt setup.py scripts/get_root_key.py /app/
COPY connaisseur /app/connaisseur

RUN ["pip3", "install", "-r", "/app/requirements.txt"]
RUN ["pip3", "install", "/app"]
RUN ["pip3", "install", "cryptography"]

USER 10001:20001

ENTRYPOINT [ "python3", "/app/get_root_key.py" ]