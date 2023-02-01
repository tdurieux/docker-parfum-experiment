FROM debian:stable-slim

RUN apt update && apt install --no-install-recommends -yq cron openssh-server nano vim && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app

COPY deploy_docker.sh run.sh ./

RUN chmod +x deploy_docker.sh && ./deploy_docker.sh && rm deploy_docker.sh && chmod +x run.sh


CMD ["./run.sh"]
