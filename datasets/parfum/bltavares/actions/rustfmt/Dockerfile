FROM rust:1.40-slim

LABEL "com.github.actions.name"="rustfmt"
LABEL "com.github.actions.description"="Provides formating and fixes for Rust using rustfmt"
LABEL "com.github.actions.icon"="user-check"
LABEL "com.github.actions.color"="purple"

LABEL "repository"="http://github.com/bltavares/actions"
LABEL "homepage"="http://github.com/bltavares/actions"
LABEL "maintainer"="Bruno Tavares <connect+githubactions@bltavares.com>"

RUN rustup component add rustfmt

RUN apt-get update -qq && apt-get install -qqy --no-install-recommends \
  curl=7.52* \
  jq=1.5* \
  bash=4.4* \
  git=1:2.11* \
  && rm -rf /var/lib/apt/lists/*

COPY lib.sh /lib.sh
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
