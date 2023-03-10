FROM growthastro/growth-too-marshal

USER root

RUN apt-get update && apt-get -y install --no-install-recommends \
    postgresql \
    postgresql-server-dev-all && \
    rm -rf /var/lib/apt/lists/*

COPY test-requirements.txt /
RUN pip3 install --no-cache-dir -r /test-requirements.txt
RUN rm /test-requirements.txt

USER growth-too-marshal

ENTRYPOINT pytest-3 -xvv --pyargs growth.too