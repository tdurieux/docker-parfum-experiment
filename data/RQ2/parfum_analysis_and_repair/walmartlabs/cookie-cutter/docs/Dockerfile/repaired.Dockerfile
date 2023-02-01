FROM node:8-jessie

WORKDIR /app/website

ENV PORT 5000
EXPOSE 5000
COPY ./docs /app/docs
COPY ./website /app/website

RUN npm install && npm cache clean --force;
RUN npm run build

CMD npm run start
