# See README.md to see how to build and run this
FROM python:3.6-slim-buster

LABEL maintainer "Chebrolu Harika <bala-sai-harika.chebrolu@hpe.com>"

WORKDIR /root

# Some optional but recommended packages
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -y \
    && apt-get install --no-install-recommends -y \
    vim \
    curl && rm -rf /var/lib/apt/lists/*;

# install dependencies to run examples
RUN python -m pip install --upgrade pip
RUN pip install --no-cache-dir hpeOneView

ADD . oneview/

WORKDIR /root/oneview

# packages to run tests
RUN cd /root/oneview/
RUN pip install --no-cache-dir -r test_requirements.txt
RUN pip install --no-cache-dir tox

# Clean and remove not required packages
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/cache/apt/archives/* /var/cache/apt/lists/* /tmp/* /root/cache/.

CMD ["/bin/bash"]