FROM node:onbuild
ADD . /code
WORKDIR /code
RUN npm install . && npm cache clean --force;
ENTRYPOINT ["/code/yelp_load"]