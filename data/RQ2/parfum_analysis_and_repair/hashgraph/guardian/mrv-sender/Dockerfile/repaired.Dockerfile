FROM node:16
ENV PLATFORM="docker"
#ENV NODE_ENV="production"

WORKDIR /usr/interfaces
COPY ./interfaces/package*.json ./
COPY ./interfaces/tsconfig.json ./
ADD ./interfaces/src ./src/.
RUN npm install && npm cache clean --force;
RUN npm pack

WORKDIR /usr/common
COPY ./common/package*.json ./
COPY ./common/tsconfig.json ./
ADD ./common/src ./src/.
RUN npm install /usr/interfaces/guardian-interfaces-*.tgz && npm cache clean --force;
RUN npm install && npm cache clean --force;
RUN npm pack

WORKDIR /usr/mrv-sender
COPY ./mrv-sender/package*.json ./
COPY ./mrv-sender/tsconfig.json ./
RUN npm install /usr/interfaces/guardian-interfaces-*.tgz /usr/common/guardian-common-*.tgz && npm cache clean --force;
RUN npm install && npm cache clean --force;
ADD ./mrv-sender/src ./src/.
ADD ./mrv-sender/public ./public/.
RUN npm run build

CMD npm start
