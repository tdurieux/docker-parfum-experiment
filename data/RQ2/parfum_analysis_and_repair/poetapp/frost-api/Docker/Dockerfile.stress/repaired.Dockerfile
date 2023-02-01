FROM node:10.13.0

RUN apt-get update -y
RUN apt-get install --no-install-recommends curl apt-transport-https -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y gnupg && rm -rf /var/lib/apt/lists/*;
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61
RUN echo "deb https://dl.bintray.com/loadimpact/deb stable main" | tee -a /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y --no-install-recommends k6 && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"