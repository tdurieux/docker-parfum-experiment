FROM ubuntu:16.04
MAINTAINER Gruntwork <info@gruntwork.io>

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

COPY . /test

CMD ["echo", "This container is used for testing. Consider running one of the test scripts under the /test folder."]
