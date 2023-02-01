FROM golang:1.17
WORKDIR /opt/build
COPY . .
RUN make install
ENTRYPOINT ["terraboard"]
CMD [""]