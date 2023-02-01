FROM circleci/golang:1.13

RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends python3-pip && rm -rf /var/lib/apt/lists/*;
RUN sudo pip3 install --no-cache-dir awscli
COPY Makefile Makefile
RUN make go-get
