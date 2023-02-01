FROM mhart/alpine-node:10

WORKDIR /app

COPY ./package*.json /app/

RUN npm install --production && npm cache clean --force;

COPY . .

CMD ["sleep", "600"]