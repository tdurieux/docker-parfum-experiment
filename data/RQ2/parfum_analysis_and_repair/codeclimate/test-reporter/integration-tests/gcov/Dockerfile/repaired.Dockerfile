FROM gcc:latest

# install go runtime
RUN curl -f -O https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz
RUN tar -xvf go1.8.linux-amd64.tar.gz && rm go1.8.linux-amd64.tar.gz
RUN mv go /usr/local

ENV PATH $PATH:/usr/local/go/bin
RUN go version

ENV GOPATH /go
RUN mkdir $GOPATH
ENV PATH $PATH:/go/bin

# install test-reporter package
ENV CCTR=$GOPATH/src/github.com/codeclimate/test-reporter
RUN mkdir -p $CCTR
WORKDIR $CCTR
COPY . .
RUN go install -v

# run gcov on example file
WORKDIR $CCTR/formatters/gcov/examples
RUN rm *.gcov
RUN gcc -fprofile-arcs -ftest-coverage *.c
RUN ./a.out
RUN gcov *.c

RUN echo "testing" > ignore.me
RUN git config --global user.email "you@example.com"
RUN git config --global user.name "Your Name"
RUN git add ignore.me
RUN git commit -m "testing"

ENV CC_TEST_REPORTER_ID=c4881e09870b0fac1291c93339b36ffe36210a2645c1ad25e52d8fda3943fb4d
RUN test-reporter format-coverage -d
RUN cat coverage/codeclimate.json
RUN test-reporter upload-coverage -d -s 2
