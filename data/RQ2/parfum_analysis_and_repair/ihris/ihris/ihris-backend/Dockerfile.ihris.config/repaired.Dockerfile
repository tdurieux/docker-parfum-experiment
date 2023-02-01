FROM node:erbium-slim

ARG branch=master
RUN apt-get -qq update && apt-get install --no-install-recommends -y -qq git && rm -rf /var/lib/apt/lists/*;
RUN git clone --branch ${branch} https://github.com/iHRIS/iHRIS /src/

# generate fsh files
WORKDIR /src/ig
RUN npm install -g fsh-sushi && npm cache clean --force;
RUN sushi -s .

WORKDIR /src/tools
RUN npm install && npm cache clean --force;

ARG IHRIS_FHIR__BASE=http://localhost:8080/hapi/fhir
ENV IHRIS_FHIR__BASE=$IHRIS_FHIR__BASE

# doesn't evaluate the shell expression correctly for fsh builds
# CMD node load.js --server $IHRIS_FHIR__BASE /src/fsh/build/input/{profiles,extensions,examples,resources,vocabulary}/*.json /src/resources/*.json

CMD node load.js --server $IHRIS_FHIR__BASE \ 
    /src/ig/fsh-generated/resources/*.json \
    && node load.js --server $IHRIS_FHIR__BASE \
    /src/resources/Basic*.json \
    /src/resources/CodeSystem*.json \
    /src/resources/DocumentReference*.json \
    /src/resources/Library*.json \
    /src/resources/Parameters*.json \
    /src/resources/Person*.json \
    /src/resources/SearchParameter*.json \
    /src/resources/ValueSet*.json
