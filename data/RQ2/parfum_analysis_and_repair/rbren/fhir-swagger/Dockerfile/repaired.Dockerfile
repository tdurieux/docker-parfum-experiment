FROM node:10
WORKDIR /usr/src/app
COPY . .
RUN npm install && npm cache clean --force;
ENTRYPOINT ["./bin/fhir-swagger"]