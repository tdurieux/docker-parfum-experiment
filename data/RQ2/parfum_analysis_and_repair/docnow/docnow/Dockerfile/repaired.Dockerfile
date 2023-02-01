FROM node:12.16.3
RUN mkdir /code
WORKDIR /code
ADD . /code/
RUN npm install && npm cache clean --force;
CMD ./entrypoint.sh
