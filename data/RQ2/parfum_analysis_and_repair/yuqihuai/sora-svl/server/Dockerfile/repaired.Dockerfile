FROM node
RUN mkdir /workdir
ADD package.json /workdir

WORKDIR /workdir

RUN npm install && npm cache clean --force;
ADD ./ /workdir

EXPOSE 3000
RUN ["npm", "run", "build"]
CMD [ "npm", "run", "start" ]