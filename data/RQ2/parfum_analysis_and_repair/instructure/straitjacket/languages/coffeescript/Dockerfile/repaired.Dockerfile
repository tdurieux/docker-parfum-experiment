FROM node:0.12

RUN npm install -g coffee-script@1.9.0 && npm cache clean --force;
RUN useradd docker
USER docker

ENTRYPOINT ["coffee"]
