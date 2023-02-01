FROM ubuntu:14.10
MAINTAINER Mesosphere, Inc. <support@mesosphere.io>
RUN apt-get update && apt-get install --no-install-recommends -y curl r-base r-base-dev r-cran-ggplot2 r-cran-sendmailR && apt-get clean && rm -rf /var/lib/apt/lists && rm -rf /var/lib/apt/lists/*;

