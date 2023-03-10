# Usage
#
# docker build --build-arg WEEK=`date +%Y%U` -t ara-build -f Dockerfile.ci .
# docker run --add-host "db:172.17.0.1" -e ARA_DB_USER=ara -e ARA_DB_PASSWORD=ara -e ARA_DB_NAME=ara_build_`date +%s` -it --rm ara-build

FROM golang:1.11

ARG WEEK
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8
ENV PACKAGES="build-essential ruby2.3-dev libpq-dev libxml2-dev zlib1g-dev git-core postgresql-client-common postgresql-client-9.6"
ENV BUNDLER_VERSION 2.0.1

RUN apt-get update && mkdir -p /usr/share/man/man1 /usr/share/man/man7 && \
    apt-get -y install --no-install-recommends locales $PACKAGES && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen && \
    gem install bundler:$BUNDLER_VERSION && rm -rf /var/lib/apt/lists/*;

WORKDIR /go/src/bitbucket.org/enroute-mobi/ara

# Install bundler packages
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --deployment

# Install application file
COPY go.mod go.sum ./

ENV GOPATH=/go
ENV GO111MODULE=on
RUN go get -d -v ./...

COPY . .

ENV TZ=Europe/Paris
ENV ARA_DB_HOST=db
CMD ["sh", "ci.sh"]
