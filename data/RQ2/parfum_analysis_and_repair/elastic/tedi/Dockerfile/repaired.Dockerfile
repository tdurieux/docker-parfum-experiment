FROM python:3.6

# Add Docker client.
RUN apt-get update && \
    apt-get -y --no-install-recommends install apt-transport-https ca-certificates curl gnupg2 software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get -y --no-install-recommends install docker-ce && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

# Add Tedi.
WORKDIR /usr/src/app

# Pre-install run-time dependencies before we install Tedi.
# This is a layer caching optimisation.
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Install Tedi.
COPY setup.* ./
COPY tedi tedi

# This next layer will be nice and small/fast because we pre-installed the
# libraries we need. If we hadn't done that, then the COPY line above would
# invalidate the layer cache and cause all the libraries to be installed every
# time.
RUN python setup.py install

WORKDIR /mnt
ENTRYPOINT ["/usr/local/bin/tedi"]
