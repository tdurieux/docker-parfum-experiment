FROM node:16-alpine3.11
WORKDIR /home/coin/
COPY app.js ./app.js
COPY index.html ./index.html
COPY package.json ./package.json
RUN npm i && npm cache clean --force;

ENV FLAG "we{testflag}"
ENV ADMIN_TOKEN "123"

CMD ["node", "app.js"]