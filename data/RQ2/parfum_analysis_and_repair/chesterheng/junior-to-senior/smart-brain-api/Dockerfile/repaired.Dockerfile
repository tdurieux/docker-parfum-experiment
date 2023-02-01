FROM node:12.16.0

WORKDIR /usr/src/smart-brain-api

COPY ./ ./

RUN npm i && npm cache clean --force;

CMD ["/bin/bash"]
