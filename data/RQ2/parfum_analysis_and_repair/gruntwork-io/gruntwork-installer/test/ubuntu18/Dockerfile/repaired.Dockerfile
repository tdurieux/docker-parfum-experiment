FROM ubuntu:18.04
MAINTAINER Gruntwork <info@gruntwork.io>

RUN apt-get update && apt-get install --no-install-recommends -y curl sudo && rm -rf /var/lib/apt/lists/*;

COPY . /test

CMD ["echo", "This container is used for testing. Consider running one of the test scripts under the /test folder."]
