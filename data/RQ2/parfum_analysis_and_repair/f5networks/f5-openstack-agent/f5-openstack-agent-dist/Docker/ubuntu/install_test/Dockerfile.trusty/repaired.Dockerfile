# Dockerfile
FROM ubuntu:trusty
COPY ./fetch_and_install_deps.py /

RUN apt-get update -y && apt-get install --no-install-recommends software-properties-common -y && rm -rf /var/lib/apt/lists/*;
RUN apt-add-repository cloud-archive:liberty
RUN apt-get update -y && apt-get dist-upgrade -y --force-yes
RUN apt-get install --no-install-recommends python-requests git curl -y --force-yes && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends python-six && rm -rf /var/lib/apt/lists/*;
RUN chmod 700 /fetch_and_install_deps.py

ENTRYPOINT ["/fetch_and_install_deps.py", "/var/wdir"]
# The following is the default, last arg if you ran the docker container on its own...
CMD ["/var/wdir/f5-openstack-agent/deb_dist/python-f5-openstack-agent_*_1404_all.deb"]

