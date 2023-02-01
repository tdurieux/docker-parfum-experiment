FROM ubuntu:20.04

WORKDIR /usr/app
RUN apt update && apt install --no-install-recommends -y libsasl2-dev python3-dev python3-pip git curl jq && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
