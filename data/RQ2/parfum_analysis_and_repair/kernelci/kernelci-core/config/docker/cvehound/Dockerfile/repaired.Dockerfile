ARG PREFIX=kernelci/
FROM ${PREFIX}coccinelle

RUN apt-get update && apt-get install --no-install-recommends -y \
    python3-pip \
    python3-setuptools \
    python3-wheel && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --system git+https://github.com/evdenis/cvehound.git@master
