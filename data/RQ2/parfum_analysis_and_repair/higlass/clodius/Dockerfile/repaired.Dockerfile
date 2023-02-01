FROM ubuntu:17.04

# TODO: Combine lines when stable
RUN apt-get update
RUN apt-get install --no-install-recommends -y bedtools=2.26.0+dfsg-3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python2.7 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pip=9.0.1-2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libcurl4-gnutls-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git=1:2.11.0-2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y zlib1g-dev && rm -rf /var/lib/apt/lists/*;
# && rm -rf /var/lib/apt/lists/*

WORKDIR /home/root

# Copy and install just the requirements.txt, so that this cache layer isn't lost when other files are modified.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN python setup.py install
RUN python setup.py build_ext --inplace
