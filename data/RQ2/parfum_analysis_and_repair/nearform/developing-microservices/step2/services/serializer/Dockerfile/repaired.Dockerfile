FROM node
RUN npm set registry http://10.100.40.254:4873
ADD . /
RUN npm install && npm cache clean --force;
CMD node serializer.js

