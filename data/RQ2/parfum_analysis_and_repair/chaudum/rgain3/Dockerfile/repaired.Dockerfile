ARG PY=3.6
ARG BASE="python:${PY}-slim"

FROM $BASE

WORKDIR /src

RUN set -x \
      && apt-get update \
      && apt-get install --no-install-recommends -y \
          gir1.2-gstreamer-1.0 \
          gstreamer1.0-plugins-base \
          gstreamer1.0-plugins-good \
          gstreamer1.0-plugins-bad \
          gstreamer1.0-plugins-ugly \
          libcairo2-dev \
          libgirepository1.0-dev \
      && apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /src/
COPY test-requirements.txt /src/
RUN pip install --no-cache-dir -r requirements.txt -r

ENTRYPOINT ["/src/tests.sh"]
