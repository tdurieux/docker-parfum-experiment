FROM golang:1.5.2

RUN apt-get clean && apt-get update && apt-get install --no-install-recommends -y make createrepo && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN go get github.com/tools/godep
ADD test_repos/ /test_repos
