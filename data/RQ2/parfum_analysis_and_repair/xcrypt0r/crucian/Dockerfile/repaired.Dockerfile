FROM ubuntu:latest

ENV TZ=US

RUN apt-get update && \
    apt-get -y --no-install-recommends install tzdata && \
    apt-get install --no-install-recommends -y curl && \
    curl -f -sL https://deb.nodesource.com/setup_12.x | bash && \
    apt-get install --no-install-recommends git -y && \
    apt-get install --no-install-recommends -y nodejs && \
    apt-get install --no-install-recommends -y ffmpeg && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/src/app

RUN npm install && npm cache clean --force;

CMD [ "npm", "start" ]