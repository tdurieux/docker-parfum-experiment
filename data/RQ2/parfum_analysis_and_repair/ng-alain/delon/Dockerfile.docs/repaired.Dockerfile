# # SSR
# FROM node:lts as dist
# MAINTAINER authors="cipchk <cipchk@qq.com>"

# WORKDIR /usr/src/app
# RUN git clone --depth 1 --branch site https://github.com/ng-alain/delon-builds.git .

# EXPOSE 80
# CMD [ "node", "server/main.js" ]