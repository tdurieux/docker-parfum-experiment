FROM node:alpine
LABEL maintainer="Jay MOULIN <jaymoulin@gmail.com> <https://twitter.com/MoulinJay>"
COPY . /root/
RUN cd /root/ && npm install && npm cache clean --force;
ENTRYPOINT ["/root/bin/cli.js"]
CMD []
