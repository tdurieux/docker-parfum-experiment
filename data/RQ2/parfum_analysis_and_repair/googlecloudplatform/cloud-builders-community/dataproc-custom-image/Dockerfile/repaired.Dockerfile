FROM google/cloud-sdk:latest

RUN apt-get -y update \
    && apt-get install --no-install-recommends python-dev -y \
    && apt-get install --no-install-recommends git curl -y && rm -rf /var/lib/apt/lists/*;

RUN curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python get-pip.py \
    && pip install --no-cache-dir -U pip \
    && pip install --no-cache-dir numpy

RUN git clone https://github.com/GoogleCloudPlatform/dataproc-custom-images.git

COPY dataproc-custom-image.sh /usr/local/bin/dataproc-custom-image.sh

ENTRYPOINT ["bash", "-C", "/usr/local/bin/dataproc-custom-image.sh"]