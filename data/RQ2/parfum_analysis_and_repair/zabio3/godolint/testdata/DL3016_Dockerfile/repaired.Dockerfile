FROM node:8.9.1

RUN npm install express && npm cache clean --force;
RUN npm install @myorg/privatepackage && npm cache clean --force;
RUN npm install express sax@0.1.1 && npm cache clean --force;
RUN npm install --global express && npm cache clean --force;
RUN npm install git+ssh://git@github.com:npm/npm.git && npm cache clean --force;
RUN npm install git+http://isaacs@github.com/npm/npm && npm install git+https://isaacs@github.com/npm/npm.git && npm cache clean --force;
RUN npm install git://github.com/npm/npm.git && npm cache clean --force;