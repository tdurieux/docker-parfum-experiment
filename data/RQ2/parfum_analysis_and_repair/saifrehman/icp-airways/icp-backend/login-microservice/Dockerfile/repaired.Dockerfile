FROM node:9.8.0
WORKDIR /usr/src/app
COPY . .
RUN npm install && npm cache clean --force;
EXPOSE 3003
RUN npm i -g webpack webpack-cli && npm cache clean --force;
RUN npm link webpack
RUN webpack-cli
RUN groupadd -g 999 appuser && \
    useradd -r -u 999 -g appuser appuser
USER appuser
CMD [ "npm", "start" ]
