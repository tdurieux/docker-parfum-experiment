FROM node:erbium-slim

ARG branch=master
RUN apt-get -qq update && apt-get install --no-install-recommends -y -qq git && rm -rf /var/lib/apt/lists/*;
RUN git clone --branch ${branch} https://github.com/iHRIS/iHRIS /src/

WORKDIR /src/tools
RUN npm install && npm cache clean --force;

ARG IHRIS_FHIR__BASE=http://localhost:8080/hapi/fhir
ENV IHRIS_FHIR__BASE=$IHRIS_FHIR__BASE

CMD node load.js --server $IHRIS_FHIR__BASE \ 
    /src/resources/demo/bundle-Country.json \
    /src/resources/demo/bundle-Region.json \
    /src/resources/demo/bundle-District.json \
    /src/resources/demo/bundle-Facility.json \
    /src/resources/demo/bundle-Practitioner.json \
    /src/resources/demo/bundle-PractitionerRole.json
