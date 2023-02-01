FROM python:3.9.13
RUN apt-get update && apt-get install --no-install-recommends -y tesseract-ocr-all imagemagick ffmpeg libsm6 libxext6 && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir poetry
WORKDIR /app
COPY . .

RUN mkdir -p /app/data/img
RUN mkdir -p /app/data/tmp
RUN mkdir -p /app/data/txt

RUN poetry install

CMD ["make", "run"]
