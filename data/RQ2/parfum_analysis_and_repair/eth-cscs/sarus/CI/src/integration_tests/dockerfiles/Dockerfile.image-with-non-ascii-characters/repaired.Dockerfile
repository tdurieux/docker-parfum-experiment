FROM alpine

# create folder and file with non-ascii characters
RUN mkdir -p /földèr && touch /földèr/filé