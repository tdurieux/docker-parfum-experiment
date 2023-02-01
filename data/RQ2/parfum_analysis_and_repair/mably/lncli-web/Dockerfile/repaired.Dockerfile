FROM node:11

EXPOSE 8280

COPY . /lncli-web

WORKDIR /lncli-web

RUN npm install \
&& ./node_modules/.bin/gulp bundles && npm cache clean --force;

CMD ["/lncli-web/init.sh"]
