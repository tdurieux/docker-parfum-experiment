FROM node:lts

COPY . /app
WORKDIR /app

RUN npm install --no-optional && npm cache clean --force;
RUN npm run build

EXPOSE $PORT

ENTRYPOINT [ "npm", "run" ]
CMD [ "start" ]
