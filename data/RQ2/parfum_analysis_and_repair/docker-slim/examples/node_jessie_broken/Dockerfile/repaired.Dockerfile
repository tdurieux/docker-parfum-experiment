FROM debian:jessie

RUN apt-get update && \
	apt-get install --no-install-recommends -y curl && \
	curl -f -sL https://deb.nodesource.com/setup_4.x | bash - && \
	apt-get install --no-install-recommends -y build-essential nodejs && \
	mkdir -p /opt/my/service && rm -rf /var/lib/apt/lists/*;

COPY service /opt/my/service

WORKDIR /opt/my/service

RUN npm install && npm cache clean --force;

EXPOSE 1300
ENTRYPOINT ["/opt/my/service/docker-entrypoint.sh"]


