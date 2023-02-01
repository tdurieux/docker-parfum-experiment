FROM python:3.9-slim

RUN apt-get update \
 && apt-get install --no-install-recommends -y mediainfo ffmpeg \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

COPY . /usr/src/app
RUN cd /usr/src/app \
 && pip install --no-cache-dir -r requirements.txt

WORKDIR /

ENTRYPOINT ["knowit"]
CMD ["--help"]
