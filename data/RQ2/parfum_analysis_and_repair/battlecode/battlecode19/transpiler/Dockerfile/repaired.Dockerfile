FROM tiangolo/uwsgi-nginx-flask:python3.6

RUN cd /usr/local && \
	curl -f -sL https://deb.nodesource.com/setup_10.x | bash - && \
	apt-get install --no-install-recommends nodejs -y && rm -rf /var/lib/apt/lists/*;

RUN	apt-get update -y && \
	# https://gist.github.com/mugli/8720670#gistcomment-1622348
	echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
	echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
	apt-key adv --no-tty --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
	apt-get update

	# Enable silent install
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
	echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
	apt-get -y --no-install-recommends install oracle-java8-installer && \
	update-java-alternatives -s java-8-oracle && \
	apt-get install --no-install-recommends -y oracle-java8-set-default && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends maven -y && \
	apt-get clean all && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir transcrypt==3.7.13 numscrypt flask-cors

COPY ./java /app/java

WORKDIR /app/java

RUN mvn generate-sources

WORKDIR /app

ENV LISTEN_PORT 80
ENV NGINX_MAX_UPLOAD 1m

copy ./repository /root/.m2/repository
copy . /app