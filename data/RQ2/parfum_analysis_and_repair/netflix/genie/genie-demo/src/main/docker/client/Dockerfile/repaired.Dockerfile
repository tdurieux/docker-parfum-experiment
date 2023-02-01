from python:3.8.3
MAINTAINER NetflixOSS <netflixoss@netflix.com>

# Pin the python libs so the image layers can be better cached/reused
RUN apt-get update && \
    apt-get install --no-install-recommends -y vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/ && \
    pip install --no-cache-dir pyyaml==5.3.1 ipython==7.16.1 nflx-genie-client==3.6.16 && rm -rf /var/lib/apt/lists/*;

COPY ./example/ /apps/genie/example/
WORKDIR /apps/genie/example
ENTRYPOINT ["/bin/bash"]
