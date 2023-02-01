FROM alpine:3.7

# We need buildkite-agent to download artifacts, and zip for Windows zipping
RUN apk --no-cache add bash zip curl \
    && curl -o /usr/bin/buildkite-agent https://download.buildkite.com/agent/stable/latest/buildkite-agent-linux-amd64 \
    && chmod +x /usr/bin/buildkite-agent
