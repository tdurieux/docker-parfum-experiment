FROM ubuntu
MAINTAINER Moritz Schlarb

RUN apt-get update
RUN apt-get -y upgrade

RUN apt-get -y --no-install-recommends install python python-pip python-numpy python-matplotlib && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install language-pack-en-base language-pack-de-base git java-sdk-headless && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir tg.devtools

ADD ["https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64.deb", "/tmp"]
RUN ["dpkg", "-i", "/tmp/dumb-init_1.2.1_amd64.deb"]

RUN mkdir -p /opt/SAUCE
COPY . /opt/SAUCE

RUN ["pip", "install", "-e", "/opt/SAUCE"]

WORKDIR /opt/SAUCE

RUN ["gearbox" ,"setup-app", "-c", "development.ini"]

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["gearbox", "serve", "-c", "development.ini"]

EXPOSE 8080
