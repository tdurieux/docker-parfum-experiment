FROM node:16

ENV NPM_CONFIG_LOGLEVEL warn

COPY . /usr/src

WORKDIR /usr/src

RUN npm run build

ENV PATH /usr/src/node_modules/.bin:$PATH

CMD ["bash"]
