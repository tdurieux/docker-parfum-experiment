FROM mhart/alpine-node:latest
RUN apk add --no-cache g++ make
RUN wget https://github.com/blechschmidt/massdns/archive/master.zip && unzip master.zip && rm master.zip
WORKDIR /massdns-master/
RUN make && make install

WORKDIR /app
COPY package.json .
RUN npm install && npm cache clean --force;
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
