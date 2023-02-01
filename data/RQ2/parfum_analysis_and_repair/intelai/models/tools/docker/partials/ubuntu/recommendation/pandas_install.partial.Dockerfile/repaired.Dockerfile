ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends --fix-missing -y \
        python-pandas && \
    pip install --no-cache-dir pandas && rm -rf /var/lib/apt/lists/*;
