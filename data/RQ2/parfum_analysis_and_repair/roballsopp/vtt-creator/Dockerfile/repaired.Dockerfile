FROM netlify/build:xenial

WORKDIR /usr/app/

COPY . ./

RUN npm install && npm cache clean --force;

CMD npm run test-ci
