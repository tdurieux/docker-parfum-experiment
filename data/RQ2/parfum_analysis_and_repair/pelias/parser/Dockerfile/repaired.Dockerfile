# base image
FROM pelias/baseimage

# change working dir
ENV WORKDIR /code/pelias/parser
WORKDIR ${WORKDIR}

# copy package.json first to prevent npm install being rerun when only code changes
COPY ./package.json ${WORKDIR}
RUN npm install && npm cache clean --force;

# copy code from local checkout
ADD . ${WORKDIR}

USER pelias

CMD [ "node", "./server/http.js" ]
