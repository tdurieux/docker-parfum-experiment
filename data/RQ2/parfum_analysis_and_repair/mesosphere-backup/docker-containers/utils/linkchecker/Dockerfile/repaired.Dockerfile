FROM mesosphere/python-monitoring:16.04
MAINTAINER Mesosphere, Inc. <support@mesosphere.io>

RUN pip uninstall -y requests
RUN apt-get install --no-install-recommends -y python-requests ca-certificates && rm -rf /var/lib/apt/lists/*;
ADD http://ftp.debian.org/debian/pool/main/l/linkchecker/linkchecker_9.3-4_amd64.deb /tmp/linkchecker_9.3-4_amd64.deb

RUN dpkg -i /tmp/linkchecker_9.3-4_amd64.deb
