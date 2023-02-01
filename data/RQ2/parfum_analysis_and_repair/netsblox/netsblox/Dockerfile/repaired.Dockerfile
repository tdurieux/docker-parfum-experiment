FROM netsblox/base

ADD . /netsblox
WORKDIR /netsblox
RUN rm -rf node_modules && npm install; npm cache clean --force; \
    mkdir -p src/client/dist; \
    npm run postinstall

EXPOSE 8080

CMD ["npm", "start"]
