FROM node:alpine

WORKDIR /usr/src/hackerrank-testcase-generator

COPY ./ ./

RUN npm install && npm cache clean --force;

ENV mongoURI mongodb://localhost:27017/hackerrank_test_case

CMD ["npm","start"]
