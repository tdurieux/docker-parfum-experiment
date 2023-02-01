#
#                                 - [ BROAD'16 ] -
#
# A docker instance for accessing AWS resources
# This wraps the cellprofiler docker registry
#


FROM cellprofiler/cellprofiler:3.1.9

# Install S3FS

RUN apt-get -y update           && \
    apt-get -y upgrade && \
    apt-get -y --no-install-recommends install \
	automake \
	autotools-dev \
	g++ \
	git \
	libcurl4-gnutls-dev \
	libfuse-dev \
	libssl-dev \
	libxml2-dev \
	make pkg-config \
	sysstat \
	curl && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/local/src
RUN git clone https://github.com/s3fs-fuse/s3fs-fuse.git
WORKDIR /usr/local/src/s3fs-fuse
RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make
RUN make install

# Install AWS CLI

RUN \
  pip install --no-cache-dir awscli

# Install boto3

RUN \
  pip install --no-cache-dir -U boto3

# Install watchtower for logging

RUN \
  pip install --no-cache-dir watchtower==0.8.0

# Install pandas for optional file downloading

RUN pip install --no-cache-dir pandas==0.24.2

# SETUP NEW ENTRYPOINT

RUN mkdir -p /home/ubuntu/
WORKDIR /home/ubuntu
COPY cp-worker.py .
COPY instance-monitor.py .
COPY run-worker.sh .
RUN chmod 755 run-worker.sh

RUN git clone https://github.com/CellProfiler/CellProfiler-plugins.git
WORKDIR /home/ubuntu/CellProfiler-plugins
#RUN pip install -r requirements.txt

WORKDIR /home/ubuntu
ENTRYPOINT ["./run-worker.sh"]
CMD [""]
