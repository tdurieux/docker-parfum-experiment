# This Dockerfile produces a docker image which is used to build the fpm docs.
FROM  debian:latest
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir Sphinx
#==1.8
RUN pip3 install --no-cache-dir sphinx_rtd_theme
RUN pip3 install --no-cache-dir alabaster
RUN pip3 install --no-cache-dir sphinx-autobuild

CMD ["/bin/bash"]
