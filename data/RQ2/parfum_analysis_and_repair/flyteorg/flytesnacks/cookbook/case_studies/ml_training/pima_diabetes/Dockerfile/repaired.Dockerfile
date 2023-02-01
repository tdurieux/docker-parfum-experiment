FROM ubuntu:focal

WORKDIR /root
ENV VENV /opt/venv
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONPATH /root

RUN : \
    && apt-get update \
    && apt install --no-install-recommends -y software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa && rm -rf /var/lib/apt/lists/*;

RUN : \
    && apt-get update \
    && apt-get install --no-install-recommends -y python3.8 python3-pip python3-venv make build-essential libssl-dev curl vim && rm -rf /var/lib/apt/lists/*;

# This is necessary for opencv to work
RUN apt-get update && apt-get install --no-install-recommends -y libsm6 libxext6 libxrender-dev ffmpeg && rm -rf /var/lib/apt/lists/*;

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

# Install Python dependencies
COPY pima_diabetes/requirements.txt /root
RUN ${VENV}/bin/pip install --no-cache-dir -r /root/requirements.txt

# Copy the makefile targets to expose on the container. This makes it easier to register.
COPY in_container.mk /root/Makefile
COPY pima_diabetes/sandbox.config /root

# Copy the actual code
COPY pima_diabetes/ /root/pima_diabetes/

# Copy over the helper script that the SDK relies on
RUN cp ${VENV}/bin/flytekit_venv /usr/local/bin/
RUN chmod a+x /usr/local/bin/flytekit_venv

# This tag is supplied by the build script and will be used to determine the version
# when registering tasks, workflows, and launch plans
ARG tag
ENV FLYTE_INTERNAL_IMAGE $tag
