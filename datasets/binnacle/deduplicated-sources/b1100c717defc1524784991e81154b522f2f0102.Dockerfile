FROM golangci/golangci-lint:v1.12.5

RUN apt-get install git

LABEL "com.github.actions.name"="Check"
LABEL "com.github.actions.description"="Run static analysis and unit tests"
LABEL "com.github.actions.icon"="check-circle"
LABEL "com.github.actions.color"="green"

COPY "entrypoint.sh" "/entrypoint.sh"
RUN chmod +x /entrypoint.sh

ENV GOFLAGS -mod=vendor
ENTRYPOINT ["/entrypoint.sh"]
