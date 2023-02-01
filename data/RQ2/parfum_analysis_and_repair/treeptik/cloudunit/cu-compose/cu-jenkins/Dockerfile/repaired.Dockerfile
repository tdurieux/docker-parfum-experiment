FROM jenkins:2.60.1

USER root

RUN apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y \
                        curl \
						ca-certificates \
						software-properties-common \
						vim && rm -rf /var/lib/apt/lists/*;

# Add nodesource PPA for specific version of node and install
RUN curl -f -sL https://deb.nodesource.com/setup_5.x | bash
RUN apt-get update && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Fix npm
RUN cd /usr/lib/node_modules/npm \
  && npm install fs-extra \
  && sed -i -e s/graceful-fs/fs-extra/ -e s/fs\.move/fs.rename/ ./lib/utils/rename.js && npm cache clean --force;

RUN npm install -g bower gulp && npm cache clean --force;

RUN add-apt-repository -y "deb http://ppa.launchpad.net/natecarlson/maven3/ubuntu precise main"
RUN apt-get update
RUN apt-get install --no-install-recommends maven3 -y --allow-unauthenticated && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/bin/mvn3 /usr/bin/mvn
RUN update-java-alternatives -s java-1.8.0-openjdk-amd64

RUN mkdir /root/.m2
ADD settings.xml /root/.m2/settings.xml

RUN rm -rf /var/lib/apt/lists/*

USER jenkins


