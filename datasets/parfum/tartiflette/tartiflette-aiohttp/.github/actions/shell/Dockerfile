FROM ruby:2-slim

LABEL "name"="Shell Action"
LABEL "maintainer"="Stan Chollet <stanislas.chollet@gmail.com>"
LABEL "version"="1.0.0"

LABEL "com.github.actions.name"="Shell Action"
LABEL "com.github.actions.description"="Action for executing shell/make commands"
LABEL "com.github.actions.icon"="filter"
LABEL "com.github.actions.color"="gray-dark"

COPY README.md /

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        bats \
        build-essential \
        ca-certificates \
        curl \
        gnupg2 \
        jq \
        git \
        make \
        shellcheck && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

CMD ["make", "run"]
