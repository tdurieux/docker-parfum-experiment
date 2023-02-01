FROM node:5

EXPOSE 8080

ADD ./ /vanilla-css

RUN cd /vanilla-css \
    && rm -rf node_modules \
    && npm install --production && npm cache clean --force;

WORKDIR /vanilla-css

CMD ["npm", "start"]
