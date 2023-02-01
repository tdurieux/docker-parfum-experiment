FROM ubuntu:20.04
MAINTAINER Gregory Wiedeman gwiedeman@albany.edu

ENV TZ=America/New_York \
    DEBIAN_FRONTEND=noninteractive \
    MAILBAGIT_LOG_LEVEL=debug\
    IN_CONTAINER=true

RUN mkdir /mailbagit
WORKDIR /mailbagit
ADD . /mailbagit/

# manually add to $PYTHONPATH because https://github.com/python/importlib_metadata/issues/364
ENV PYTHONPATH=/mailbagit

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install --no-install-recommends -y build-essential && \
    apt-get install --no-install-recommends -y libgtk-3-dev && \
    apt-get install --no-install-recommends -y python3-pip && \
    apt-get install --no-install-recommends -y curl && \

    pip install --no-cache-dir libpff-python==20211114 && \

    curl -f -L -o /tmp/wkhtmltox_0.12.6-1.focal_amd64.deb \
       https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb && \
    apt-get install --no-install-recommends -y /tmp/wkhtmltox_0.12.6-1.focal_amd64.deb && \

    curl -f -L -o /tmp/google-chrome-stable_current_amd64.deb \
        https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get install --no-install-recommends -y /tmp/google-chrome-stable_current_amd64.deb && \

    pip install --no-cache-dir -e .[pst] && rm -rf /var/lib/apt/lists/*;
