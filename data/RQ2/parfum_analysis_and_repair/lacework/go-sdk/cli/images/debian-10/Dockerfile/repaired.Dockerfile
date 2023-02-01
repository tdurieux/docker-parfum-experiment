FROM  debian:10
LABEL maintainer="tech-ally@lacework.net" \
      description="The Lacework CLI helps you manage the Lacework cloud security platform"

RUN apt-get update && apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
COPY ./LICENSE /
RUN curl -f https://raw.githubusercontent.com/lacework/go-sdk/main/cli/install.sh | bash
