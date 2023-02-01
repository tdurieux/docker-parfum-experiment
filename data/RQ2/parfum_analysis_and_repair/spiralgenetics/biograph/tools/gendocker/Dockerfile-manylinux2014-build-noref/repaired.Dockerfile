FROM quay.io/pypa/manylinux2014_x86_64

# Packages biograph uses:
RUN yum install -y libpng-devel libxml2-devel libxslt-devel expect-devel \
					bzip2-devel openssl samtools words && rm -rf /var/cache/yum

# These are necessary for static linking, and don't have to be
# installed if we're only doing dynamic linking:
RUN yum install -y libstdc++-static glibc-static libsepol-static libxml2-static \
    libselinux-static zlib-static pcre-static glib2-static libpng-static zip && rm -rf /var/cache/yum

# Packages used by biograph for tests:
RUN yum install -y htslib-tools vcftools && rm -rf /var/cache/yum

RUN ln -s /opt/python/cp36-cp36m/bin/python /usr/bin/python3 && \
    ln -s /opt/python/cp36-cp36m/bin/python /usr/bin/python3.6


