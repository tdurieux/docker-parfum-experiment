FROM node:latest
RUN mkdir /src
RUN cd /src
COPY package.json /src
WORKDIR /src
RUN npm install -g typescript@2.7.2 && npm cache clean --force;
RUN cd /src && npm install && npm cache clean --force;
COPY . /src
CMD ["sh", "./develop.sh"]