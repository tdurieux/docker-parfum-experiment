FROM python:3.9-slim

RUN apt-get update && \
    apt-get install --no-install-recommends -y bison flex && rm -rf /var/lib/apt/lists/*;

# install luke requirements
RUN pip install --no-cache-dir pybison tqdm six watchdog cython

COPY entrypoint.sh /entrypoint.sh
WORKDIR /github/workspace

ENTRYPOINT ["/entrypoint.sh"]
