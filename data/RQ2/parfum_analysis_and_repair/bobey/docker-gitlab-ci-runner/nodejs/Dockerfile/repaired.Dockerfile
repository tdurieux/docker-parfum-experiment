# docker-gitlab-ci-runner-nodejs

FROM bobey/docker-gitlab-ci-runner
MAINTAINER  Olivier Balais "obalais@gmail.com"

RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository -y ppa:chris-lea/node.js && \
    apt-get update && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
