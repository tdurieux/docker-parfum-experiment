FROM node:8.12

WORKDIR /usr/app

COPY . .

RUN npm i && npm cache clean --force;

CMD ["/bin/bash"]
# bring up bash shell https://www.ctl.io/developers/blog/post/dockerfile-entrypoint-vs-cmd/