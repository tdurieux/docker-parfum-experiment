FROM node

RUN npm install -g nodemon && npm cache clean --force;

ENV HOME /home
RUN mkdir -p $HOME
WORKDIR $HOME

COPY package.json ./

RUN yarn install && yarn cache clean;

COPY /src ./src/

EXPOSE 3001

CMD ["npm", "run", "start"]
