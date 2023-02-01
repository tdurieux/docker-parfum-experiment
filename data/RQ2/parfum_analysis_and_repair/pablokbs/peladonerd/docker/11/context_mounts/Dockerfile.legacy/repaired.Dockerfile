FROM alpine

COPY . files/
RUN tar -cf files.tar files && rm files.tar
RUN rm -rf files
