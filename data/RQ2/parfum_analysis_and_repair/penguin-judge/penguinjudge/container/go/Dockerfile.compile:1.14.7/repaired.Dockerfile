FROM golang:1.14.7
RUN go get -u gonum.org/v1/gonum/... && \
    go get -u github.com/emirpasic/gods/... && \
    go clean -cache
COPY config.compile.json /config.json
COPY penguin_judge_agent /bin
CMD ["/bin/penguin_judge_agent"]