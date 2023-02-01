FROM python:3.9-slim-bullseye
COPY *.whl .
RUN apt update -qy && \
    apt install --no-install-recommends -qy pkg-config gcc libcairo2-dev && \
    pip install --no-cache-dir -qq *.whl && \
    rm *.whl && rm -rf /var/lib/apt/lists/*;
