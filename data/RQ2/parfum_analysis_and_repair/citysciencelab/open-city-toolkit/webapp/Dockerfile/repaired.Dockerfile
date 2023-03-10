# Pull base system
FROM debian:buster

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV GEOSERVER_DATA_DIR=/usr/share/geoserver/data_dir

# Install utilities
RUN apt-get update
RUN apt-get install --no-install-recommends -y locales curl grass-core enscript ghostscript && rm -rf /var/lib/apt/lists/*;

# Install locale
RUN sed -i -e 's/# \(en_US\.UTF-8 .*\)/\1/' /etc/locale.gen && locale-gen

# Install Node.js
RUN curl -f -L https://deb.nodesource.com/setup_15.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean

# Install webapp
WORKDIR /oct
RUN mkdir -p data_from_browser
COPY package*.json ./webapp/
RUN cd webapp && npm ci
COPY . webapp

WORKDIR /oct/webapp
CMD node app.js
