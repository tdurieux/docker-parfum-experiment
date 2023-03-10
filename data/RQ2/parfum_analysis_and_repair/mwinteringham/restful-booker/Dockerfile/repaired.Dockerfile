FROM node:lts

# Copy restful-booker across
RUN mkdir /restful-booker

COPY ./ /restful-booker/

WORKDIR /restful-booker

RUN npm install && npm cache clean --force;

CMD npm start
