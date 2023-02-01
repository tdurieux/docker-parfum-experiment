FROM secretless-dev

RUN apt-get update && \
    apt-get install --no-install-recommends -y groff \
                       python-pip && \
    pip install --no-cache-dir awscli && rm -rf /var/lib/apt/lists/*;
