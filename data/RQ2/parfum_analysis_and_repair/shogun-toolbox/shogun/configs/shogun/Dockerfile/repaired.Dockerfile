FROM ubuntu:16.04
MAINTAINER shogun@shogun-toolbox.org

RUN apt-get update && apt-get install -y --no-install-recommends -qq software-properties-common lsb-release && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) multiverse"
RUN add-apt-repository ppa:shogun-toolbox/nightly
RUN apt-get update -qq
RUN apt-get upgrade -y

# install shogun
RUN apt-get install -y -qq --force-yes --no-install-recommends libshogun18 && rm -rf /var/lib/apt/lists/*;
