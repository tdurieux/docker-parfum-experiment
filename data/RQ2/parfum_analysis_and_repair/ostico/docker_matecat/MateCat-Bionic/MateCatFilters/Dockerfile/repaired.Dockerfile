FROM ostico/bionic-base:latest

RUN apt-get update
RUN apt-get -y full-upgrade

RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN apt-get update
RUN apt-get install --no-install-recommends -y git software-properties-common && \
    add-apt-repository -y ppa:openjdk-r/ppa && \
    apt-get update && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y openjdk-8-jre && rm -rf /var/lib/apt/lists/*;

COPY data /

COPY startFilter.sh /tmp/startFilter.sh
RUN chmod +x /tmp/startFilter.sh
CMD ["/tmp/startFilter.sh"]
