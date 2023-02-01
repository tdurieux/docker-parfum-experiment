FROM quentinlc/jessie-lxc:latest

MAINTAINER Quent Laporte-Chabasse

RUN apt-get update && \
  curl -f -sL https://deb.nodesource.com/setup_4.x | bash - && \
  apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN npm install sigver -g && npm cache clean --force;


EXPOSE 8000

CMD ["sigver"]
