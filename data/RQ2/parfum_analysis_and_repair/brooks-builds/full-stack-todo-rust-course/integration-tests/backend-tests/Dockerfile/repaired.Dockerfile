FROM node:14
VOLUME /code
WORKDIR /code
RUN npm i && npm cache clean --force;
ENV API_PORT=3000
ENV API_URI=http://localhost
CMD npm run test:watch