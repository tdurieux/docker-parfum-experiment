FROM google/cloud-sdk:latest

RUN apt-get update && apt-get --yes --no-install-recommends install openjdk-11-jre && rm -rf /var/lib/apt/lists/*;

ADD bin/pipeline5.sh pipeline5.sh
ADD target/lib /usr/share/pipeline5/lib
ARG VERSION
ADD target/cluster-$VERSION.jar /usr/share/pipeline5/bootstrap.jar

ENTRYPOINT ["./pipeline5.sh"]
