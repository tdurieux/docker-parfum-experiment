FROM tianon/ubuntu-core:14.04
ENV BLOCKCHAIN_PATH /var/blockchain
RUN mkdir -p $BLOCKCHAIN_PATH
COPY dnaNode $BLOCKCHAIN_PATH
EXPOSE 20334 20335 20336 20337 20338 20339
WORKDIR $BLOCKCHAIN_PATH
ENTRYPOINT ["./dnaNode"]