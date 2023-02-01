FROM exiasr/alpine-yarn-nginx
RUN apk add --no-cache git python g++ make

ENV WORKING_DIR=/opt/docs

RUN mkdir -p ${WORKING_DIR}
COPY ./ ${WORKING_DIR}
WORKDIR ${WORKING_DIR}

RUN npm install && npm cache clean --force;
RUN ls -la
RUN npm run install