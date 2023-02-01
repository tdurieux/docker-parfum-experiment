FROM ubuntu
MAINTAINER Benjamin Faal

ENV SHARED_KEY FILL_KEY_IN
ENV TURN_IP FILL_TURN_IP_IN
ENV TURN_PORT FILL_TURN_PORT_IN

RUN apt-get update -y

RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

# Google App Engine and Python 2.7
ENV GAE_VER 1.9.23
ENV GAE_ZIP go_appengine_sdk_linux_amd64-$GAE_VER.zip

RUN apt-get update && \
    apt-get install --no-install-recommends --yes \
        unzip \
	python && rm -rf /var/lib/apt/lists/*;

ADD https://storage.googleapis.com/appengine-sdks/featured/$GAE_ZIP .
RUN unzip -q $GAE_ZIP -d /usr/local
RUN rm $GAE_ZIP
ENV PATH $PATH:/usr/local/go_appengine/

RUN apt-get install --no-install-recommends python2.7 python-pil -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python-webtest -y && rm -rf /var/lib/apt/lists/*;

# NodeJS
RUN wget -O nodejs.sh https://deb.nodesource.com/setup_4.x
RUN chmod +x nodejs.sh
RUN sh ./nodejs.sh

RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# symlink nodejs to node
RUN ln -s -f /usr/bin/nodejs /usr/bin/node

RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

# GIT
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/BenjaminFaal/apprtc

EXPOSE 8080

WORKDIR apprtc

RUN npm install -g npm && npm cache clean --force;
RUN npm install -g grunt-cli && npm cache clean --force;

RUN npm install && npm cache clean --force;
RUN grunt build

COPY run.sh /

WORKDIR /
RUN chmod +x /run.sh
CMD /run.sh
