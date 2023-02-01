FROM node:0.10

# TUT-660 Temporary fix for CVE-2015-7547
RUN apt-get update -q && apt-get install --no-install-recommends -yq libc6 && apt-get clean && rm -rf /var/lib/apt/lists/*;

ADD . /app

WORKDIR /app

RUN npm install && npm cache clean --force;

ENV PORT 80
EXPOSE 80

CMD ["node", "server.js"]
