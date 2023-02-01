FROM dockerfile/nodejs

COPY package.json /seguir/package.json
RUN cd /seguir; npm install && npm cache clean --force;
COPY . /seguir

WORKDIR /seguir

EXPOSE 3000

CMD ["node", "server"]
