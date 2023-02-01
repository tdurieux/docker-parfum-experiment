FROM node

RUN git clone https://github.com/jacobmischka/ics-merger.git
WORKDIR /ics-merger
RUN yarn install && yarn cache clean;

COPY ./env.json /ics-merger/env.json
COPY ./run.sh /run.sh

RUN yarn build && yarn cache clean;

EXPOSE 3000/tcp

ENTRYPOINT ["/run.sh"]
