FROM node:10

ADD . /src
WORKDIR /src
RUN npm install --silent && npm cache clean --force;

CMD ["make", "deps", "build", "test-and-publish"]
