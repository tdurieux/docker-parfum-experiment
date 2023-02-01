FROM quay.io/pypa/manylinux2010_x86_64

RUN yum install -y libffi-devel libmagic-devel libzlib-devel libfreetype6-devel \
                   libpng-devel libxml2-devel libxslt-devel expect-devel liblzma-devel \
                   libenchant-devel libpq-devel libz-devel openssl samtools words bzip2-devel && rm -rf /var/cache/yum

RUN ln -s /opt/python/cp36-cp36m/bin/python /usr/bin/python3 && \
    ln -s /opt/python/cp36-cp36m/bin/python /usr/bin/python3.6
