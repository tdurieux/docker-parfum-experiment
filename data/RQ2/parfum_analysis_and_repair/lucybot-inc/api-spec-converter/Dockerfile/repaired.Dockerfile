FROM node
ADD . api-spec-converter/
RUN cd api-spec-converter && npm install && npm cache clean --force;
RUN npm i -g ./api-spec-converter && npm cache clean --force;
