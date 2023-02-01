FROM python:3.7

RUN apt-get update && apt-get install -y --assume-yes --no-install-recommends python3-pip >=20.0.2 nodejs >=10.15.2 \
 && apt-get clean && rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
WORKDIR /workspace/atomai
