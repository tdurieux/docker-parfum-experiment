FROM golang:1.17-alpine

RUN apk add --no-cache bash \
                       build-base \
                       git \
                       libffi-dev \
                       ruby-bundler \
                       ruby-dev

# Install summon prerequisites
WORKDIR /summon
COPY go.mod go.sum ./
RUN go mod download

# Install test (Ruby) prerequisites
WORKDIR /summon/acceptance
COPY acceptance/Gemfile acceptance/Gemfile.lock ./
RUN bundle install

# Build summon
WORKDIR /summon
COPY . .
COPY ./dist/goreleaser/summon-linux_linux_amd64_v1/summon /bin/summon

# Run tests
WORKDIR /summon/acceptance
CMD ["cucumber"]