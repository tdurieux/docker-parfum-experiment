FROM node


WORKDIR /app
RUN npm install -g gatsby-cli && npm cache clean --force;

COPY ./ ./


RUN npm install && npm cache clean --force;

# run gatsby develop

CMD [ "gatsby", "build" ]