FROM debian:testing
MAINTAINER andrew.page@quadram.ac.uk

RUN apt-get update -qq && apt-get install --no-install-recommends -y git python3 python3-setuptools python3-biopython python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir cython

RUN pip3 install --no-cache-dir git+git://github.com/andrewjpage/tiptoft.git

WORKDIR /data