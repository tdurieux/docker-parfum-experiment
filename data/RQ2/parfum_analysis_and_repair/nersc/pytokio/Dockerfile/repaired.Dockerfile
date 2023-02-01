#
#  Simple Docker container to run tests of a fully packaged source distribution
#  of pytokio in a clean environment.
#
FROM centos

# setup build env
RUN yum -y update && yum -y install python3 && yum -y clean all && rm -rf /var/cache/yum
RUN python3 -mensurepip --upgrade
RUN pip3 install --no-cache-dir nose setuptools

WORKDIR /build

COPY . .
RUN python3 setup.py sdist
RUN pip3 install --no-cache-dir ./dist/pytokio-*.tar.gz
CMD ./tests/run_tests.sh
