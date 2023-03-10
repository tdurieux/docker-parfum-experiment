FROM logicalspark/docker-tikaserver

WORKDIR /

# get python
RUN apt-get update && apt-get upgrade -y && apt-get clean \
    && apt install --no-install-recommends -y software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get install --no-install-recommends -y curl python3.7 python3.7-dev python3.7-distutils \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1 \
    && update-alternatives --set python /usr/bin/python3.7 \
    && curl -f -s https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python get-pip.py --force-reinstall \
    && rm get-pip.py \
    && pip uninstall numpy -y && rm -rf /var/lib/apt/lists/*;

# setup the workspace
COPY . /workspace
WORKDIR /workspace

# install the third-party requirements
RUN pip install --no-cache-dir -r requirements.txt

# for testing the image
RUN pip install --no-cache-dir pytest && pytest

ENTRYPOINT ["jina", "pod", "--uses", "config.yml"]