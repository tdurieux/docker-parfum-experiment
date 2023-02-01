FROM python:3.7

WORKDIR /usr/src/app
COPY . .

RUN pip install --no-cache-dir bandit coveralls && \
    pip install --no-cache-dir . && \
    pip install --no-cache-dir -r requirements-test.txt && \
    python setup.py develop && \
    repokid config config.json# Generate example config

ENTRYPOINT ["repokid"]
