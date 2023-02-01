FROM node:16-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq -y update \
    && apt-get -qq --no-install-recommends -y install python build-essential && rm -rf /var/lib/apt/lists/*;

RUN mkdir /alephui
WORKDIR /alephui

COPY .npmrc /alephui/.npmrc
COPY tsconfig.json /alephui/tsconfig.json
COPY package.json /alephui

RUN npm install && npm cache clean --force;

COPY i18n /alephui/i18n
COPY public /alephui/public
RUN cp /alephui/node_modules/pdfjs-dist/build/pdf.worker.min.js /alephui/public/static/
COPY src /alephui/src

ENV REACT_APP_API_ENDPOINT /api/2/
# RUN npm run build
