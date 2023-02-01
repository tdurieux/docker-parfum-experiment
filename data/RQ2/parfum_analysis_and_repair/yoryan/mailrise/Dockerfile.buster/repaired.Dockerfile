# first stage
FROM python:3.9-buster AS builder
WORKDIR /code
COPY . .
RUN pip install --user --no-cache-dir --use-feature=in-tree-build --no-warn-script-location .

# second stage