# Dockerfile
FROM centos:7

RUN yum update -y && yum install git python-requests -y && rm -rf /var/cache/yum
RUN yum install -y python-six && rm -rf /var/cache/yum

COPY ./fetch_and_install_deps.py /

# ENTRYPOINT ["python", "-m", "pdb", "/fetch_and_install_deps.py", "/var/wdir"]
ENTRYPOINT ["python", "/fetch_and_install_deps.py", "/var/wdir"]
# by default, the following will be used for the last arg:
CMD ["/var/wdir/f5-sdk-dist/rpms/build/f5-sdk-*.el7.noarch.rpm"]
