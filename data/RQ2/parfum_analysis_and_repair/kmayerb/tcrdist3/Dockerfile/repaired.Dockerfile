FROM ubuntu:20.04

RUN apt-get update --fix-missing && \
  apt-get install --no-install-recommends -y wget bzip2 ca-certificates curl git unzip && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install --no-install-recommends -y python3 && apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir python-levenshtein==0.12.0
RUN pip3 install --no-cache-dir pytest
RUN pip3 install --no-cache-dir jedi==0.17.2
RUN pip3 install --no-cache-dir ipython==7.18.1
RUN pip3 install --no-cache-dir git+https://github.com/kmayerb/tcrdist3.git@0.2.2
RUN pip3 install --no-cache-dir requests
RUN python3 -c "from tcrdist.setup_tests import *; download_and_extract_zip_file('dash.zip', dest = '.')"

CMD [ "/bin/bash" ]
