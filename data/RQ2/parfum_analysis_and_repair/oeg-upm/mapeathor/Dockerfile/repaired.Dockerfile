FROM ubuntu:18.04
MAINTAINER David Chaves<dachafra@gmail.com>

USER root

# Python 3.6
RUN apt-get update && \
    apt-get install -y --no-install-recommends nano wget git curl less psmisc && \
    apt-get install -y --no-install-recommends python3.6 python3-pip python3-setuptools && \
    pip3 install --no-cache-dir --upgrade pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;


COPY . /mapeathor
RUN cp /mapeathor/run.sh .
RUN cd /mapeathor && pip3 install --no-cache-dir -r requirements.txt

CMD ["tail", "-f", "/dev/null"]
