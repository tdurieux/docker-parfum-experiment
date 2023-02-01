FROM python:3.8.11

RUN apt-get update && apt-get install --no-install-recommends -y python3-opencv && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir requests

WORKDIR /workdir/
COPY requirements.txt .
COPY superb_import.py .

RUN pip install --no-cache-dir -r requirements.txt