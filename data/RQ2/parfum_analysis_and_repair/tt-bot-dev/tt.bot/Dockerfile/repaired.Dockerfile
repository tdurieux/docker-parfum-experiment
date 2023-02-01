FROM node:alpine
RUN apk add --no-cache git

ENV HOME /app
COPY . /app
WORKDIR /app
RUN npm i && npm cache clean --force;
USER nobody

EXPOSE 8826

CMD ["node", "."]