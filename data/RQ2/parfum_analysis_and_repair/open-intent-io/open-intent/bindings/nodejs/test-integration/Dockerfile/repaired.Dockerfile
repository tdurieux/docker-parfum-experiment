FROM open-intent
MAINTAINER open-intent.io

RUN npm install -g mocha && npm cache clean --force;

RUN /entrypoint.sh

WORKDIR /chatbot

CMD ["mocha"]