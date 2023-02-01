FROM debian:jessie

RUN apt-get update && apt-get install --no-install-recommends -y curl tar && curl -f -L https://github.com/AdoptOpenJDK/openjdk9-openj9-releases/releases/download/jdk-9%2B181/OpenJDK9-OPENJ9_x64_Linux_jdk-9.181.tar.gz | tar xvz && rm -rf /var/lib/apt/lists/*;

