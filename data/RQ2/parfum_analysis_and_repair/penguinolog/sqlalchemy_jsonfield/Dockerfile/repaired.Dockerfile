FROM python:slim
# Build tools. Mandatory for the future tests support
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y libpq-dev gcc && rm -rf /var/lib/apt/lists/*;
# Test runner and actual packaging tools
RUN pip install --no-cache-dir -U setuptools tox pip
# Copy tests
ADD . /mnt/test
WORKDIR /mnt/test

# Default target: run functional tests, which requires FS access.
CMD tox -e functional
