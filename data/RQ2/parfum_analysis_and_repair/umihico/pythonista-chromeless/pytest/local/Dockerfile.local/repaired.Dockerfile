FROM python:3.8-buster

RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    apt install --no-install-recommends -y tesseract-ocr tesseract-ocr-jpn && rm -rf /var/lib/apt/lists/*;

COPY pytest/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /work
COPY chromeless ./chromeless
COPY pytest/local/local.py .
RUN mkdir /tmp/chromeless