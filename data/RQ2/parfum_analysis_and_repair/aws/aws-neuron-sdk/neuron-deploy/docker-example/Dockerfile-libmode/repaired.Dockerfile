# Example pytorch neuron container
# To build:
#    docker build . -f Dockerfile.pt -t neuron-container:pytorch
# To run on EC2 Inf1 instances with AWS DLAMI:
#    docker run -it --device=/dev/neuron0 neuron-container:pytorch

FROM ubuntu:18.04

LABEL maintainer=" "

RUN apt-get update -y \
 && apt-get install -y --no-install-recommends \
    gnupg2 \
    wget \
    python3-pip \
    python3-setuptools \
    && pip3 --no-cache-dir install --upgrade pip && rm -rf /var/lib/apt/lists/*;

RUN echo "deb https://apt.repos.neuron.amazonaws.com bionic main" > /etc/apt/sources.list.d/neuron.list

# If you are facing certficate error issues, add  `--no-check-certificate` to the following wget line as a flag.
RUN wget -qO - https://apt.repos.neuron.amazonaws.com/GPG-PUB-KEY-AMAZON-AWS-NEURON.PUB | apt-key add -

# Installing Neuron Tools
RUN apt-get update -y && apt-get install --no-install-recommends -y \
    aws-neuron-tools && rm -rf /var/lib/apt/lists/*;

# Clean up cache
RUN rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Sets up Path for Neuron tools
ENV PATH="/opt/bin/:/opt/aws/neuron/bin:${PATH}"

# Include framework tensorflow-neuron or torch-neuron and compiler (compiler not needed for inference)
RUN pip3 --no-cache-dir install \
    torch-neuron \
    --extra-index-url=https://pip.repos.neuron.amazonaws.com

# Include your APP dependencies here.
# RUN ...

# Define the entrypoint script that has some application code (if needed) and executes the docker run command
# For example you can use something like below
# COPY dockerd-libmode-entrypoint.sh /opt/bin/dockerd-entrypoint.sh
# RUN chmod +x /opt/bin/dockerd-entrypoint.sh
# ENTRYPOINT ["/opt/bin/dockerd-entrypoint.sh"]

CMD ["neuron-top"]
