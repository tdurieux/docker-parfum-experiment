FROM node:14-alpine


COPY ./ /opt/wolf/server
WORKDIR /opt/wolf/server
RUN npm install && npm cache clean --force;

EXPOSE 12180
ENTRYPOINT ["sh", "./entrypoint.sh"]
