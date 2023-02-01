FROM ubuntu:xenial

RUN apt update \
    && apt upgrade -y

RUN apt install --no-install-recommends gcc build-essential git gzip arduino gawk curl -y && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -; apt install --no-install-recommends nodejs -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt/server

COPY src /opt/server

RUN npm install && npm cache clean --force;

RUN mkdir -p /opt/builder

EXPOSE 8888

CMD ["node", "app.js"]