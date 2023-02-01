FROM python:3

WORKDIR /app

COPY . /app

RUN apt-get update && \
    apt-get -y --no-install-recommends install tesseract-ocr libtesseract-dev && \
    python -m pip install -r requirements.txt && rm -rf /var/lib/apt/lists/*;

WORKDIR /data

ENTRYPOINT [ "python", "/app/basecrack.py" ]