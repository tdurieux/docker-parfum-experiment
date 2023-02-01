FROM node:4

RUN npm install -g drupal-project-loader && npm cache clean --force;

RUN mkdir /data

WORKDIR /data

ENTRYPOINT ["drupal-project-loader"]
