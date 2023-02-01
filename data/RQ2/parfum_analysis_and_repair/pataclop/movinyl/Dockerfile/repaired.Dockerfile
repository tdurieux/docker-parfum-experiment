FROM ubuntu:20.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends tzdata && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install --no-install-recommends -y build-essential libopencv-dev python3-opencv ffmpeg bc && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
    apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Install gosu
RUN set -eux; \
	apt-get update; \
	apt-get install --no-install-recommends -y gosu; \
	rm -rf /var/lib/apt/lists/*; \
# verify that the binary works
	gosu nobody true

RUN useradd app

COPY src /app/src

WORKDIR /app

RUN mkdir PROCESSING_ZONE

RUN cd src/disk && make
RUN cd src/page && make
RUN cd src/pymdb && python3 setup.py install

COPY . /app

RUN chown -R app:app /app

ENV PYTHONUNBUFFERED 1

ENTRYPOINT ["/app/docker-entrypoint.sh", "/app/movinyl.py"]
