FROM ubuntu:20.04

RUN apt-get update && \
		DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install tzdata && \
		apt-get install --no-install-recommends -y nodejs npm && \
		mkdir -p /opt/my/service && rm -rf /var/lib/apt/lists/*;

COPY service /opt/my/service

WORKDIR /opt/my/service

RUN npm install && npm cache clean --force;

EXPOSE 1300
ENTRYPOINT ["node","/opt/my/service/server.js"]


