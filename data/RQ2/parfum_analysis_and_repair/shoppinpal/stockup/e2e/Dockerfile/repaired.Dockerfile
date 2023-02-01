FROM node:6.10.3
COPY . /project
WORKDIR /project
RUN npm install -g protractor && npm cache clean --force;
RUN npm install && npm cache clean --force;
ENTRYPOINT [ "protractor" ]