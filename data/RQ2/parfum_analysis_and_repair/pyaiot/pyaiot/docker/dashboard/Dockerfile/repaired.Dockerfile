FROM pyaiot/base:latest

LABEL maintainer="alexandre.abadie@inria.fr"

RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_13.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN cd /opt && git clone https://github.com/pyaiot/pyaiot
RUN cd /opt/pyaiot/pyaiot/dashboard/static && npm install && cd && npm cache clean --force;

ADD run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 8080

CMD ["/run.sh"]
