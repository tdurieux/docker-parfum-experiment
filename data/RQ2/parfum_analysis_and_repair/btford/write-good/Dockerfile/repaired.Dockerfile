FROM node:dubnium
COPY . /tmp/write-good
RUN yarn global add --no-progress file:/tmp/write-good && yarn cache clean;
WORKDIR /srv/app
ENTRYPOINT ["write-good"]
CMD ["--help"]
