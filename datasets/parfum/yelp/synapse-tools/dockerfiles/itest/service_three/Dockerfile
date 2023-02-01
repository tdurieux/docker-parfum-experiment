FROM ubuntu:18.04
ARG PIP_INDEX_URL=https://pypi.yelpcorp.com/simple
ENV PIP_INDEX_URL=$PIP_INDEX_URL
RUN apt-get update && apt-get install -y git python python-setuptools python-pip
RUN git clone https://github.com/Yelp/hacheck
RUN cd /hacheck && pip install .

# Hacheck
EXPOSE 6666

# Create a dummy service running on port 1024 and serving up /my_healthcheck_endpoint
EXPOSE 1024
WORKDIR /tmp
RUN echo 'OK' > my_healthcheck_endpoint

# Run hacheck in background and dummy service in foreground
CMD /usr/local/bin/hacheck -p 6666 & python -m SimpleHTTPServer 1024
