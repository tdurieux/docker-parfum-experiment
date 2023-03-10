FROM tensorflow/tensorflow:1.15.0

# Install golang
RUN apt-get update && apt-get install --no-install-recommends -y wget git gcc && rm -rf /var/lib/apt/lists/*;

RUN wget -P /tmp https://storage.googleapis.com/golang/go1.10.2.linux-amd64.tar.gz

RUN tar -C /usr/local -xzf /tmp/go1.10.2.linux-amd64.tar.gz && rm /tmp/go1.10.2.linux-amd64.tar.gz
RUN rm /tmp/go1.10.2.linux-amd64.tar.gz

RUN pip install --no-cache-dir grpcio-tools

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

ENV TENSORFLOW_LIB_GZIP libtensorflow-cpu-linux-x86_64-1.15.0.tar.gz
ENV TARGET_DIRECTORY /usr/local
RUN  curl -fsSL "https://storage.googleapis.com/tensorflow/libtensorflow/$TENSORFLOW_LIB_GZIP" -o $TENSORFLOW_LIB_GZIP && \
     tar -C $TARGET_DIRECTORY -xzf $TENSORFLOW_LIB_GZIP && \
     rm -Rf $TENSORFLOW_LIB_GZIP
ENV LD_LIBRARY_PATH $TARGET_DIRECTORY/lib
ENV LIBRARY_PATH $TARGET_DIRECTORY/lib

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888

WORKDIR "/notebooks"


CMD ["/run_jupyter.sh", "--allow-root"]
