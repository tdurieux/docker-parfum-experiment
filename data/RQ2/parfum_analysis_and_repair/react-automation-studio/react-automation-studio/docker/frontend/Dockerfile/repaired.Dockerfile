FROM node:14.15.3
WORKDIR /frontend
ENV PATH /frontend/node_modules/.bin:$PATH
ADD ./ReactApp/package.json /frontend/package.json

RUN npm install && npm cache clean --force;
ADD ./ReactApp/public /frontend/public
ADD ./ReactApp/src /frontend/src
ADD  ./.env /frontend/
RUN npm run build
VOLUME /build
CMD cp -R /frontend/build/* /build/

