FROM node:18

RUN mkdir /workplace/
COPY gen/ /workplace/gen

RUN mkdir /workplace/tmp
RUN git clone https://github.com/googleapis/google-cloudevents /workplace/tmp
RUN mv /workplace/tmp/tools/quicktype-wrapper /workplace/gen/quicktype-wrapper

WORKDIR /workplace/gen/quicktype-wrapper
RUN npm install && npm cache clean --force;

WORKDIR /workplace/gen/
RUN npm install quicktype-wrapper/ && npm cache clean --force;
RUN npm install && npm cache clean --force;
RUN npm link

CMD gen
