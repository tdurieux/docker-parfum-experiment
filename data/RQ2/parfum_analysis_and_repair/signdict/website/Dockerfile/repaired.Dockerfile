FROM elixir:1.9-slim

RUN apt-get update && \
    apt-get install --no-install-recommends -y git build-essential inotify-tools curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g yarn && npm cache clean --force;

RUN mkdir signdict

COPY . /signdict

EXPOSE 4000
CMD sh -c "/signdict/docker-entrypoint.sh"
