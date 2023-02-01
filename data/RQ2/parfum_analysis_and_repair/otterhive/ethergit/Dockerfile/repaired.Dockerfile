FROM node
WORKDIR /srv/app
COPY package.json /srv/app/package.json
RUN npm install && npm cache clean --force;
COPY . /srv/app
CMD npm run dev
