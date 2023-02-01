FROM node:14

COPY package.json package-lock.json /app/
WORKDIR /app

RUN npm i && rm -rf /root/.node-gyp /root/.npm && npm cache clean --force;

COPY . /app/

CMD ["npm", "start"]
