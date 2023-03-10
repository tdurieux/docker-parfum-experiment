FROM node:14-alpine

# g++ gcc libgcc libstdc++ linux-headers make

COPY ./ /opt/wolf/server
WORKDIR /opt/wolf/server
RUN npm --registry https://registry.npm.taobao.org install && npm cache clean --force;

EXPOSE 12180
ENTRYPOINT ["sh", "./entrypoint.sh"]
