FROM redis:latest
FROM poseidon:latest
RUN apk upgrade --no-cache && \
    apk add --no-cache \
    build-base \
    python3-dev \
    yaml-dev && \
    pip3 install --no-cache-dir -r test-requirements.txt && \
    pip3 install --no-cache-dir -r api/requirements.txt
CMD py.test -v -vv --cov-report term-missing --cov=. -c .coveragerc
