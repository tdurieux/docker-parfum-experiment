# Define a builder image
FROM python:3.10-bullseye as builder

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
RUN apt-get update \
 && apt-get install -yq --no-install-recommends \
    ca-certificates \
    libcurl4-gnutls-dev \
    libgnutls28-dev \
    libmemcached-dev \
    git \
    nodejs \
    npm

# Build requirements
COPY ./requirements-dev.txt  /srv/nbviewer/
RUN python3 -mpip install -r /srv/nbviewer/requirements-dev.txt

WORKDIR /srv/nbviewer

# Copy source tree in
COPY . /srv/nbviewer
RUN python3 setup.py build && \
    python3 -mpip wheel -vv -r requirements.txt . -w /wheels

# Now define the runtime image
FROM python:3.10-slim-bullseye
LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

RUN apt-get update \
 && apt-get install -yq --no-install-recommends \
    ca-certificates \
    libcurl4 \
    libmemcached11 \
    git \
 && apt-get clean && rm -rf /var/lib/apt/lists/*


COPY --from=builder /wheels /wheels
RUN python3 -mpip install --no-cache /wheels/*

# To change the number of threads use
# docker run -d -e NBVIEWER_THREADS=4 -p 80:8080 nbviewer
ENV NBVIEWER_THREADS 2
WORKDIR /srv/nbviewer
EXPOSE 8080
USER nobody

EXPOSE 9000
CMD ["python", "-m", "nbviewer", "--port=8080"]
