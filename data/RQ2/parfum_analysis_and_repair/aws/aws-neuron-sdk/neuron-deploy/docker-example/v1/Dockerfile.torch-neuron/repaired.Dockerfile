# Example pytorch neuron container
# Note: a dockerd_entrypoint.sh script is required to succesfully build this image. Place the script on the same folder as the Dockerfile
# To build:
#    docker build . -f Dockerfile.pt -t neuron-container:pytorch
# To run on EC2 Inf1 instances with AWS DLAMI:
#    sudo service neuron-rtd stop
#    docker run -it --device=/dev/neuron0 --cap-add IPC_LOCK neuron-container:pytorch

FROM ubuntu:18.04

LABEL maintainer=" "

RUN apt-get update -y \
 && apt-get install -y --no-install-recommends \
    gnupg2 \
    wget \
    python3-pip \
    python3-setuptools \
    libcap-dev \
    && cd /usr/local/bin \
    && pip3 --no-cache-dir install --upgrade pip \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

RUN echo "deb https://apt.repos.neuron.amazonaws.com bionic main" > /etc/apt/sources.list.d/neuron.list
RUN wget -qO - https://apt.repos.neuron.amazonaws.com/GPG-PUB-KEY-AMAZON-AWS-NEURON.PUB | apt-key add -

# Installing Neuron Runtime and Tools
RUN apt-get update -y && apt-get install --no-install-recommends -y \
    aws-neuron-runtime \
    aws-neuron-tools && rm -rf /var/lib/apt/lists/*;

# Sets up Path for Neuron tools
ENV PATH="/opt/bin/:/opt/aws/neuron/bin:${PATH}"

# Include framework tensorflow-neuron or torch-neuron and compiler (compiler not needed for inference)
RUN pip3 install --no-cache-dir \
    torch-neuron \
    --extra-index-url=https://pip.repos.neuron.amazonaws.com

# Include your APP dependencies here.
# RUN ...

# Define the entrypoint script that starts the runtime and executes the docker run command
COPY dockerd-entrypoint.sh /opt/bin/dockerd-entrypoint.sh
RUN chmod +x /opt/bin/dockerd-entrypoint.sh
ENTRYPOINT ["/opt/bin/dockerd-entrypoint.sh"]

CMD ["neuron-top"]
