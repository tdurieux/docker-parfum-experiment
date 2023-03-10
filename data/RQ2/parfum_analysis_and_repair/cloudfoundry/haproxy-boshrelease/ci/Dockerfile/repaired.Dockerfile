FROM bosh/main-bosh-docker

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y --no-install-recommends wget && rm -rf /var/lib/apt/lists/*;
RUN wget -q -O - https://raw.githubusercontent.com/starkandwayne/homebrew-cf/master/public.key | apt-key add -
RUN echo "deb http://apt.starkandwayne.com stable main" | tee /etc/apt/sources.list.d/starkandwayne.list
RUN apt-get update
RUN apt-get -y --no-install-recommends install jq spruce git vim && rm -rf /var/lib/apt/lists/*;

ENV GOPATH=/go
RUN mkdir /go
RUN go get -u github.com/onsi/ginkgo/ginkgo
