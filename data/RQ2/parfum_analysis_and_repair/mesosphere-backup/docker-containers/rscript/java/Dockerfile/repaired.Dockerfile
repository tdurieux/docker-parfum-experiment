FROM mesosphere/rscript-curl-aws
MAINTAINER Mesosphere, Inc. <support@mesosphere.io>
RUN apt-get update && apt-get install --no-install-recommends -y openjdk-7-jdk && apt-get clean && rm -rf /var/lib/apt/lists && rm -rf /var/lib/apt/lists/*;
