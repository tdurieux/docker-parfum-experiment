FROM phusion/baseimage:latest-amd64

RUN apt-get update && apt-get upgrade -y
RUN add-apt-repository ppa:openjdk-r/ppa -y

RUN apt-get update && apt-get install --no-install-recommends -y \
  iputils-ping \
  python2.7 \
  python-pip \
  httpie \
  jq \
  openjdk-8-jdk && \
  apt-get clean && rm -rf /var/lib/apt/lists/*;

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

RUN pip install --no-cache-dir --upgrade pip wheel setuptools supervisor

ADD supervisor.sed /tmp/supervisor.sed

RUN echo_supervisord_conf > /etc/supervisord.conf && \
  sed -i -r -f /tmp/supervisor.sed /etc/supervisord.conf && \
  mkdir -p /etc/supervisor/conf.d

CMD ["supervisord", "-c", "/etc/supervisord.conf", "-n"]
