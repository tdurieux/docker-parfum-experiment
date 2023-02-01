FROM ubuntu:bionic

RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-dev python3-pip python3-setuptools gcc-6 g++-6 git openssh-client && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -U --user utils numpy

###### install the AWS CLI required for result upload to S3
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update; apt-get -y --no-install-recommends install awscli && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /root/.ssh
WORKDIR /root

# Run example:
#   python3 examples/tutorials/mlp.py
CMD ["/bin/bash"]

