FROM python:3.7-slim-buster
WORKDIR /work

RUN apt-get update && apt-get install --no-install-recommends -y make git wget lbzip2 unzip && rm -rf /var/lib/apt/lists/* && pip3 install --no-cache-dir --upgrade pip && pip3 install --no-cache-dir nrfutil
COPY docker/* ./
RUN chmod +x ./pre.sh && ./pre.sh
COPY . .
RUN chmod +x ./post.sh && ./post.sh

ENTRYPOINT ["/bin/bash"]
