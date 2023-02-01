FROM ubuntu:18.04

WORKDIR /inspec

#MAINTAINER Rodney Bizzell

RUN apt update -y \
    && apt upgrade -y \
    && apt install --no-install-recommends -y python3 python3-dev python3-pip curl \
    && apt clean all \
    && rm -rf /var/cache/apt && rm -rf /var/lib/apt/lists/*;

RUN ln -s $(command -v pip3) /usr/bin/pip
# python must be pointing to python3.6
RUN ln -s $(command -v python3) /usr/bin/python
RUN pip install --no-cache-dir awscli
RUN curl -f https://omnitruck.chef.io/install.sh | bash -s -- -P inspec
RUN inspec plugin install train-aws --chef-license accept


COPY uchi-inspec.sh uchi-inspec.sh

COPY uchi-inspec-policy uchi-inspec-policy

ENTRYPOINT ["/bin/sh","/inspec/uchi-inspec.sh"]
