FROM golang:1.17.8

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq \
 && apt-get install --no-install-recommends -qq -y --force-yes \
     apt-transport-https \
     apt-utils \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common \
 && curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add - \
 && add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" && rm -rf /var/lib/apt/lists/*;
RUN apt-get update -qq \
 && apt-get install --no-install-recommends -qq -y --force-yes docker-ce=17.12.0~ce-0~debian && rm -rf /var/lib/apt/lists/*;

WORKDIR /src
