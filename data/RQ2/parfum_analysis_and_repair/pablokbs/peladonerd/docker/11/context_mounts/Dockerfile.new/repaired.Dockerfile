FROM alpine

RUN --mount=target=./files \
  tar -cf files.tar files && rm files.tar
