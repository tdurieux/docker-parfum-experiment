FROM ubuntu:focal

ENV VENV /opt/venv
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONPATH /root

RUN apt-get update \
    && apt-get install --no-install-recommends -y software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get install -y \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
    cmake \
    curl \
    python3.8 \
    python3.8-venv \
    python3.8-dev \
    make \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-pip \
    zlib1g-dev \
    vim \
    wget && rm -rf /var/lib/apt/lists/*;

# Install the AWS cli separately to prevent issues with boto being written over
RUN pip3 install --no-cache-dir awscli

WORKDIR /opt
RUN curl -f https://sdk.cloud.google.com > install.sh
RUN bash /opt/install.sh --install-dir=/opt
ENV PATH $PATH:/opt/google-cloud-sdk/bin
WORKDIR /root

# Virtual environment
ENV VENV /opt/venv
RUN python3 -m venv ${VENV}
ENV PATH="${VENV}/bin:$PATH"

# Download BLAST
RUN wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.12.0/ncbi-blast-2.12.0+-x64-linux.tar.gz && \
    tar -xzf ncbi-blast-2.12.0+-x64-linux.tar.gz && rm ncbi-blast-2.12.0+-x64-linux.tar.gz

ENV PATH=".:/ncbi-blast-2.12.0+/bin:${PATH}"

# Check if BLAST is installed
RUN echo $(blastx)

# Set the working directory
WORKDIR /root

# Install Python dependencies
COPY blast/requirements.txt /root
RUN ${VENV}/bin/pip install --no-cache-dir -r /root/requirements.txt

# Copy the makefile targets to expose on the container. This makes it easier to register.
COPY in_container.mk /root/Makefile
COPY blast/sandbox.config /root

# Copy the actual code
COPY blast/ /root/blast/

# Copy over the helper script that the SDK relies on
RUN cp ${VENV}/bin/flytekit_venv /usr/local/bin/
RUN chmod a+x /usr/local/bin/flytekit_venv

# This tag is supplied by the build script and will be used to determine the version
# when registering tasks, workflows, and launch plans
ARG tag
ENV FLYTE_INTERNAL_IMAGE $tag
ENV FLYTE_SDK_USE_STRUCTURED_DATASET TRUE
