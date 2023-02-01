FROM python:3.8

LABEL org.opencontainers.image.source https://github.com/serengil/deepface

COPY . .

RUN apt-get update && apt-get install --no-install-recommends ffmpeg libsm6 libxext6 -y && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir .

CMD ["deepface", "--help"]