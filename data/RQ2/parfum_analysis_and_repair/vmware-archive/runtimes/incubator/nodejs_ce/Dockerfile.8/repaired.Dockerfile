FROM node:8

RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;

ADD lib/helper.js kubeless_rt/lib/
ADD kubeless.js kubeless_rt/
ADD package.json kubeless_rt/
ADD kubeless-npm-install.sh /

WORKDIR kubeless_rt/

RUN npm install && npm cache clean --force;

USER 1000

CMD ["node", "kubeless.js"]
