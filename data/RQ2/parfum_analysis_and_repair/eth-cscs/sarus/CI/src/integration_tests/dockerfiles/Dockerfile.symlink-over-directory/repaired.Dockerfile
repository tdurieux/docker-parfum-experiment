FROM alpine

# Create a directory, and replace it with a symlink in a later layer
RUN mkdir -p /usr/local/test && touch /usr/local/test/file
RUN mv /usr/local/test /opt/ && ln -s /opt/test /usr/local/test