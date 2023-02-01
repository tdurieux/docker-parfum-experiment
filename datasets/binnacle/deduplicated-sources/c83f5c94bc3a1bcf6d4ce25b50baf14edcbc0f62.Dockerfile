FROM debian:stable-slim

LABEL "name"="filter"
LABEL "maintainer"="GitHub Actions <support+actions@github.com>"
LABEL "version"="1.1.0"

LABEL "com.github.actions.name"="Filters for GitHub Actions"
LABEL "com.github.actions.description"="Common filters to stop workflows"
LABEL "com.github.actions.icon"="filter"
LABEL "com.github.actions.color"="gray-dark"

COPY LICENSE README.md THIRD_PARTY_NOTICE.md /

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        jq && \
	apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

ENV PATH="/usr/local/bin:${PATH}"

COPY bin /usr/local/bin/
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
