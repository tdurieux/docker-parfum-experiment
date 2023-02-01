from python:3.6-slim

run apt update && apt install --no-install-recommends -y make curl && rm -rf /var/lib/apt/lists/*;

run python -m pip install --upgrade pip

run pip install --no-cache-dir requests rocketchat-py-sdk elasticsearch

add ./analytics /analytics
workdir /analytics

cmd python replay.py
