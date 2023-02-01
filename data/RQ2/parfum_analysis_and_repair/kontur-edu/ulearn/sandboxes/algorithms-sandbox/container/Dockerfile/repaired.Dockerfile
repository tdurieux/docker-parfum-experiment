FROM ubuntu:20.04

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 14.15.3
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Ekaterinburg

RUN apt-get update && apt-get -y upgrade && apt-get install --no-install-recommends -y wget && apt-get -y --no-install-recommends install curl \
	# Python 3.8
	&& apt-get -y --no-install-recommends install python3.8 \
	# C, C++
	&& apt-get -y --no-install-recommends install build-essential \
	# C#
	&& wget https://packages.microsoft.com/config/ubuntu/20.10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
	&& dpkg -i packages-microsoft-prod.deb \
	&& apt-get update && apt-get install --no-install-recommends -y apt-transport-https && apt-get install --no-install-recommends -y dotnet-sdk-5.0 \
	&& apt-get install --no-install-recommends -y apt-transport-https && apt-get install --no-install-recommends -y dotnet-runtime-5.0 && rm -rf /var/lib/apt/lists/*;

	# Java
RUN apt-get install --no-install-recommends -y openjdk-14-jdk \
	# JavaScript
	&& curl -f --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash \
	&& . $NVM_DIR/nvm.sh \
	&& nvm install $NODE_VERSION \
	&& nvm alias default $NODE_VERSION \
	&& nvm use default && rm -rf /var/lib/apt/lists/*;

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
ENV NODE_REPL_HISTORY ''


COPY ./app/ /app/

WORKDIR app

RUN useradd student && chmod 700 /app/tests