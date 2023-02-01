FROM node:8.11.3-slim

RUN npm install -g rpscript && npm cache clean --force;
RUN rps install basic
RUN echo "log 'hello world'" > test.rps

CMD rps test.rps
