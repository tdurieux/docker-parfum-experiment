FROM ubuntu:21.10

RUN apt-get update -y && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f -kL \
  -o /usr/bin/art \
  https://bintray.com/artifact/download/jfrog/artifactory-cli-go/1.2.1/artifactory-cli-linux-amd64/art && \
  chmod +x /usr/bin/art

WORKDIR /src

ENTRYPOINT [ "art" ]
