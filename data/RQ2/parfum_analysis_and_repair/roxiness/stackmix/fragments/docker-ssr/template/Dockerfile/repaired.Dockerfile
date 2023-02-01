FROM node:current-alpine
RUN apk add --no-cache git

RUN mkdir /code
WORKDIR /code

COPY . /code/
RUN npm install && npm cache clean --force;

CMD ["npm", "run", "serve:ssr"]


