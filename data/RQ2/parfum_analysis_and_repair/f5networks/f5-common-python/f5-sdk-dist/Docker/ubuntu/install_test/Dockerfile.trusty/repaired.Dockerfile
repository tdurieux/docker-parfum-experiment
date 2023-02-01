# Dockerfile
FROM ubuntu:trusty

RUN apt-get update -y && apt-get install --no-install-recommends software-properties-common -y && rm -rf /var/lib/apt/lists/*;
# liberty does not have python-six 1.10.0+
RUN apt-add-repository cloud-archive:liberty
RUN apt-get update -y && apt-get dist-upgrade -y --force-yes
RUN apt-get install --no-install-recommends python-requests git curl -y --force-yes && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends python-six && rm -rf /var/lib/apt/lists/*;

COPY ./fetch_and_install_deps.py /

RUN chmod 700 /fetch_and_install_deps.py
ENTRYPOINT ["/fetch_and_install_deps.py", "/var/wdir"]
# The following is the default, last arg if you ran the docker container on its own...
CMD ["/var/wdir/f5-sdk-dist/deb_dist/python-f5-sdk_*_1404_all.deb"]
