FROM python:2.7.14-slim

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

# Install needed packages
RUN apt-get update \
  && apt-get install --no-install-recommends -y \
  gcc \
  zip && rm -rf /var/lib/apt/lists/*;

# Install pip dependencies
RUN pip install --no-cache-dir virtualenv

WORKDIR /usr/src/app

COPY ./build-deployment-package.sh /

ENTRYPOINT ["/bin/bash", "/build-deployment-package.sh"]
