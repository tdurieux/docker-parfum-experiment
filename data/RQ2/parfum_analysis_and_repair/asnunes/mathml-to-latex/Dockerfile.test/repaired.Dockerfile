FROM node:14.17
WORKDIR /usr/src/mathml-to-latex
RUN npm -g i npm && npm cache clean --force;
COPY ./package*.json ./
RUN npm install && npm cache clean --force;
COPY . .