FROM ubuntu
ENV GOPATH=/baxx/
RUN apt-get update && apt-get -y upgrade && apt-get install --no-install-recommends -y mdadm ca-certificates && rm -rf /var/lib/apt/lists/*;
ADD bin /baxx
ADD t /baxx/src/github.com/jackdoe/baxx/help/t

