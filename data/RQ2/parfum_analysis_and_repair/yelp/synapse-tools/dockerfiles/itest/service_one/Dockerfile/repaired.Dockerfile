FROM ubuntu:18.04
ARG PIP_INDEX_URL=https://pypi.yelpcorp.com/simple
ENV PIP_INDEX_URL=$PIP_INDEX_URL
RUN apt-get update && apt-get install --no-install-recommends -y git python python-setuptools python-pip && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/Yelp/hacheck
RUN cd /hacheck && pip install --no-cache-dir .

RUN apt-get -y --no-install-recommends install socat && rm -rf /var/lib/apt/lists/*;

# Hacheck
EXPOSE 6666

# Run hacheck in background and dummy service in foreground
EXPOSE 1025
CMD /usr/local/bin/hacheck -p 6666 & socat TCP4-LISTEN:1025,fork SYSTEM:date
