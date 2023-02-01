# Based on Dockerfile from Docker.io documentation.
FROM base

RUN apt-get update; apt-get --yes --no-install-recommends install make python-pip python-setuptools && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir Sphinx==1.2.1
RUN pip install --no-cache-dir sphinxcontrib-httpdomain==1.2.0

CMD ["make", "-C", "/docs", "clean", "server"]
EXPOSE 8000