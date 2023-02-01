FROM mhart/alpine-node
RUN npm install deepstream.io && npm cache clean --force;
RUN mkdir /code
WORKDIR /code
ADD ./start.js /code/
CMD ["node","start.js"]
