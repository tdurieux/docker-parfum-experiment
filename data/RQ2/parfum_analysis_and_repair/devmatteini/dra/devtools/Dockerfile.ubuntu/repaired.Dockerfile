FROM devmatteini/dra-ubuntu-base
ARG GITHUB_TOKEN
ENV GITHUB_TOKEN=$GITHUB_TOKEN
COPY ./target/debug/dra /usr/local/bin/dra