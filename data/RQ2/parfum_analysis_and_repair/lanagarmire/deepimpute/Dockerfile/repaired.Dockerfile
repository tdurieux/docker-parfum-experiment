FROM tensorflow/tensorflow

MAINTAINER Breck Yunits <byunits@cc.hawaii.edu>

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/lanagarmire/deepimpute && cd deepimpute && pip install --no-cache-dir --user .