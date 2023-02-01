FROM golang:1.17

RUN apt-get update
RUN apt-get install --no-install-recommends -y ruby ruby-dev rubygems build-essential && rm -rf /var/lib/apt/lists/*;
RUN gem install --no-ri --no-rdoc fpm
ENV GOPATH=/tmp/go

RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y rsync && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gcc && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y bash && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y tar && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y rpm && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p $GOPATH/src/github.com/github/gh-ost
WORKDIR $GOPATH/src/github.com/github/gh-ost
COPY . .
RUN bash build.sh
