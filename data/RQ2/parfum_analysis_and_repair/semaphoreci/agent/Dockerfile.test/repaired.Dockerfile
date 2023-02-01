FROM python:3

RUN apt-get update && \
  apt-get install --no-install-recommends curl -y && \
  curl -f -sSL https://get.docker.com/ | sh && \
  apt-get install --no-install-recommends -y ssh && \
  pip install --no-cache-dir docker-compose awscli && rm -rf /var/lib/apt/lists/*;

ADD server.key /app/server.key
ADD server.crt /app/server.crt
ADD build/agent /app/agent

WORKDIR /app

CMD service ssh restart && ./agent serve
