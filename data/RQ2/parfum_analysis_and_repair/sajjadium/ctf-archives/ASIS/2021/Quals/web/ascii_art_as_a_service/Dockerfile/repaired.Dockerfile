FROM ubuntu:21.10

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y nodejs npm jp2a && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y


ENV TERM=xterm
ENV NODE_ENV=production
WORKDIR /app
COPY ./app/ /app/
RUN npm install && npm cache clean --force;
RUN chmod +x ./index.js
RUN chmod 777 /app/request
RUN chmod 777 /app/output
RUN useradd -m www
USER www
CMD /app/index.js 2>/dev/null