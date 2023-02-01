# Dockerfile for lowest common denominator Linux native artifact build
# --------------------------------------------------------------------
# Cribbed from TileDB-Py/misc/pypi_linux/Dockerfile2010
FROM quay.io/pypa/manylinux2010_x86_64

RUN yum install -y java-1.8.0-openjdk-devel && rm -rf /var/cache/yum
RUN yum remove -y cmake

ENV PATH /opt/python/cp38-cp38/bin:${PATH}
RUN pip install --no-cache-dir cmake==3.17.3
