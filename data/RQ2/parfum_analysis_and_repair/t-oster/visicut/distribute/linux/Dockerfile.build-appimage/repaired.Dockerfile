FROM alpine:latest

SHELL ["sh", "-x", "-c"]

RUN apk add --no-cache libc6-compat gcompat openjdk11 git wget python3 shellcheck bash make maven && \
    python3 -m ensurepip && \
    python3 -m pip install git+https://github.com/TheAssassin/appimagecraft.git#egg=appimagecraft