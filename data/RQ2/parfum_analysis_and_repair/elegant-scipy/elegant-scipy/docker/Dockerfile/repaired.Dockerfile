FROM debian:buster

RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common apt-utils && \
    apt-get install --no-install-recommends -y python3.6 python3.6-dev curl zip \
                       libffi-dev libssl-dev npm git \
                       python-pip python3-pkg-resources python3-setuptools \
                       libxml2-utils blahtexml locales && \
    rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    /usr/sbin/locale-gen


# gsutil is installed to deploy the book to Google Cloud Storage
RUN pip2 install --no-cache-dir gsutil

# Install Python dependencies
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.6 1 && \
    curl -f https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py && \
    python /tmp/get-pip.py && \
    pip install --no-cache-dir --upgrade pip ipykernel && \
    python -m ipykernel install --user

# Install dependencies for HTMLBook build
RUN npm install -g htmlbook && npm cache clean --force;

# Download big data files
# (Potential refactor: use Wercker's cache to store data files)
RUN mkdir /data && \
    curl -f https://hgdownload.cse.ucsc.edu/goldenPath/dm6/bigZips/dm6.fa.gz \
         -o /data/dm6.fa.gz
