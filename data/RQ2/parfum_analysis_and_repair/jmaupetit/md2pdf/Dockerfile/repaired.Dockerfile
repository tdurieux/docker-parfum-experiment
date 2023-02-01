FROM ubuntu:latest

MAINTAINER Julien Maupetit <julien@maupetit.net>

# Install weasyprint dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
      python3-dev \
      python3-pip \
      python3-cffi \
      libcairo2 \
      libpango1.0-0 \
      libgdk-pixbuf2.0-0 \
      libffi-dev \
      shared-mime-info && \
    apt-get -y clean && rm -rf /var/lib/apt/lists/*;

COPY . /usr/local/src/md2pdf

RUN cd /usr/local/src/md2pdf && \
    pip3 install --no-cache-dir -r requirements.txt && \
    python3 setup.py install

VOLUME ["/app"]
WORKDIR /app
ENTRYPOINT ["md2pdf"]
