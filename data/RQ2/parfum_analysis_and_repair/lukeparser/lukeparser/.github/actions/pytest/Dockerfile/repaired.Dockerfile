FROM python:slim

RUN apt-get update && \
    apt-get install --no-install-recommends -y bison flex && rm -rf /var/lib/apt/lists/*;

# install luke requirements
RUN pip install --no-cache-dir pybison tqdm six watchdog pytest

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
WORKDIR /github/workspace/tests

ENTRYPOINT ["/entrypoint.sh"]
