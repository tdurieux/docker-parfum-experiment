FROM moov/watchman:latest
COPY ./test/testdata/ /data/static/
ENV INITIAL_DATA_DIRECTORY=/data/static