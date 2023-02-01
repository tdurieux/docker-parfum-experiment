FROM kkarczmarczyk/node-yarn

COPY . /react-c3js

WORKDIR /react-c3js
RUN make build

WORKDIR docs
RUN rm -rf node_modules && \
  yarn && yarn cache clean;

EXPOSE 9966
CMD npm start
