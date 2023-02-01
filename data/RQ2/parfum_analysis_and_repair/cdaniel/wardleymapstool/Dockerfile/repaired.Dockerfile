FROM ubuntu:vivid

# Setup NodeSource Official PPA
RUN apt-get update && \
    apt-get install --no-install-recommends -y --force-yes \
    curl \
    apt-transport-https \
    lsb-release \
    build-essential \
    python-all && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup | bash -

RUN apt-get install --no-install-recommends nodejs -y --force-yes && rm -rf /var/lib/apt/lists/*;

#mongo
RUN apt-get install --no-install-recommends -y --force-yes mongodb && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /data/db

#supervisor
RUN apt-get install --no-install-recommends -y --force-yes supervisor && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#phantomjs
RUN apt-get install --no-install-recommends -y --force-yes phantomjs && rm -rf /var/lib/apt/lists/*;

ADD . /srv
WORKDIR /srv
# install the dependencies
RUN npm install && npm cache clean --force;


EXPOSE 8080
CMD ["/usr/bin/supervisord"]

