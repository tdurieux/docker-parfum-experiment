FROM node:12

# install required libs, docker-compose and yarn
RUN apt-get update && apt-get install --no-install-recommends python-pip -y && pip install --no-cache-dir docker-compose && rm -rf /var/lib/apt/lists/*;

# create folder and set it as workdir
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# copy binary
COPY bin/server-core.js /usr/src/app/server-core.js
COPY bin/exoframe-server.js /usr/src/app/exoframe-server.js

# copy home.html
COPY bin/home.html /usr/src/app/home.html

# expose ports
EXPOSE 8080

CMD ["node", "exoframe-server.js"]
