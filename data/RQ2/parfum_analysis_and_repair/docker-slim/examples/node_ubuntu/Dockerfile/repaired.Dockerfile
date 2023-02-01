FROM ubuntu:14.04

RUN apt-get update && \
		apt-get install --no-install-recommends -y curl software-properties-common python-software-properties && \
		add-apt-repository ppa:chris-lea/node.js && \
		apt-get update && \
		apt-get install --no-install-recommends -y build-essential \
		nodejs && \
		mkdir -p /opt/my/service && rm -rf /var/lib/apt/lists/*;

COPY service /opt/my/service

WORKDIR /opt/my/service

RUN npm install && npm cache clean --force;

EXPOSE 1300
ENTRYPOINT ["node","/opt/my/service/server.js"]


