FROM continuumio/miniconda

WORKDIR /app

ADD . /app

RUN pip install --no-cache-dir -r dev-requirements.txt && \
    pip install --no-cache-dir -r test-requirements.txt && \
    pip install --no-cache-dir -e . && \
    apt-get install --no-install-recommends -y gnupg && \
    curl -f -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    cd mlflow/server/js && \
    npm install && \
    npm run build && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;
