FROM alpine:latest

ENV DEBIAN_FRONTEND noninteractive
ENV LANG='C.UTF-8'

# Use Native Package Manager
RUN apk update && apk upgrade
RUN apk add --no-cache python3

# Upgrade 'pip' package manager
RUN pip3 -q --no-cache-dir install --upgrade pip

# Add Python Scripts
ADD install.py .

# Run Python Scripts
RUN python3 install.py
