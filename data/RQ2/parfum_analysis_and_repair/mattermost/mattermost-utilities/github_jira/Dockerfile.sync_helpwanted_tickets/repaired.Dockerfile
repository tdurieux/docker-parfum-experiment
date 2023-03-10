FROM golang:1.16.5 as build

WORKDIR /usr/src/app

COPY ./ ./
RUN CGO_ENABLED=0 go build

FROM alpine:3.14

ENV EXTRA_ARGS= GITHUB_TOKEN= JIRA_TOKEN= JIRA_USERNAME= WEBHOOK_URL=

COPY --from=build /usr/src/app/github_jira /usr/bin/github_jira

CMD ["sh", "-c", "/usr/bin/github_jira synchelpwanted --webhook-url $WEBHOOK_URL --jira-token $JIRA_TOKEN --jira-username $JIRA_USERNAME --github-token $GITHUB_TOKEN $EXTRA_ARGS"]