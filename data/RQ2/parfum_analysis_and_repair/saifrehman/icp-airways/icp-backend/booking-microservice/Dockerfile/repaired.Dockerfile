FROM node:9.8.0
WORKDIR /usr/src/app
COPY . .
RUN npm install && npm cache clean --force;
RUN npm i -g webpack webpack-cli && npm cache clean --force;
RUN webpack-cli
EXPOSE 3000
RUN groupadd -g 999 appuser && \
    useradd -r -u 999 -g appuser appuser
USER appuser
CMD [ "node", "dist/bundle-be.js" ]
