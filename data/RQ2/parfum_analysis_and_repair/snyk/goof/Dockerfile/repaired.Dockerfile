# FROM node:6-stretch
FROM node:14.1.0

RUN mkdir /usr/src/goof && rm -rf /usr/src/goof
RUN mkdir /tmp/extracted_files
COPY . /usr/src/goof
WORKDIR /usr/src/goof

RUN npm update
RUN npm install && npm cache clean --force;
EXPOSE 3001
EXPOSE 9229
ENTRYPOINT ["npm", "start"]
