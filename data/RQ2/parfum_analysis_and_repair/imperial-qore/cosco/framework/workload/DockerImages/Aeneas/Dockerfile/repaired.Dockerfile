FROM ubuntu:18.04


WORKDIR /root

RUN \
    apt-get update && apt-get install --no-install-recommends -y \
    autoconf \
    build-essential \
    libtool \
    time \
    bc \
    python \
    python-pip \
    git && rm -rf /var/lib/apt/lists/*;

RUN \
    apt-get install --no-install-recommends -y \
    wget && rm -rf /var/lib/apt/lists/*;

RUN \
    pip install --no-cache-dir boto3

RUN \
    git init && \
    git remote add -f origin https://github.com/qub-blesson/DeFog.git && \
    git config core.sparsecheckout true && \
    echo Aeneas/aeneas/ >> .git/info/sparse-checkout && \
    git pull https://github.com/qub-blesson/DeFog.git master

RUN \
    cd Aeneas/aeneas && \
    bash install_dependencies.sh && \
    pip install --no-cache-dir -r requirements.txt && \
    python setup.py build_ext --inplace

COPY execute.sh .
RUN chmod +x execute.sh

COPY assets assets

CMD ["./execute.sh"]
