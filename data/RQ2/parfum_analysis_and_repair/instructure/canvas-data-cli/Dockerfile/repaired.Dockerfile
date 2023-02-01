FROM instructure/node:10

USER root
RUN mkdir -p /usr/src/app/report && chown -R docker /usr/src/app && rm -rf /usr/src/app/report
USER docker

ADD package.json package.json
RUN npm install . --ignore-scripts && rm package.json && npm cache clean --force;
ADD . /usr/src/app

CMD npm test
