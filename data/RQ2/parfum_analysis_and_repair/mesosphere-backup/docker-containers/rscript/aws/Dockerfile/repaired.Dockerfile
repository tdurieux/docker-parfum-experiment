FROM mesosphere/rscript-curl
MAINTAINER Mesosphere, Inc. <support@mesosphere.io>
RUN apt-get update && apt-get install --no-install-recommends -y python-pip && apt-get clean && rm -rf /var/lib/apt/lists && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir awscli

