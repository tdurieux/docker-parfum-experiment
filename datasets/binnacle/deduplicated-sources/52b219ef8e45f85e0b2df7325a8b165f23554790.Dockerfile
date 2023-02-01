FROM alpine:3.2

# Here we use several hacks collected from https://github.com/gliderlabs/docker-alpine/issues/11:
# 1. install GLibc (which is not the cleanest solution at all)
# 2. hotfix /etc/nsswitch.conf, which is apperently required by glibc and is not used in Alpine Linux

# Install glibc
RUN apk add --update wget ca-certificates && \
    export ALPINE_GLIBC_BASE_URL="https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64" && \
    export ALPINE_GLIBC_PACKAGE="glibc-2.21-r2.apk" && \
    export ALPINE_GLIBC_BIN_PACKAGE="glibc-bin-2.21-r2.apk" && \
    wget "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE" "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_BIN_PACKAGE" && \
    apk add --allow-untrusted "$ALPINE_GLIBC_PACKAGE" "$ALPINE_GLIBC_BIN_PACKAGE" && \
    /usr/glibc/usr/bin/ldconfig "/lib" "/usr/glibc/usr/lib" && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
    apk del wget ca-certificates && \
    rm "$ALPINE_GLIBC_PACKAGE" "$ALPINE_GLIBC_BIN_PACKAGE" /var/cache/apk/*

# Install python compiled for glibc
RUN apk add --update bash wget ca-certificates && \
    wget "http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh" && \
    bash ./Miniconda-latest-Linux-x86_64.sh -b -p /usr/local/miniconda && \
    rm ./Miniconda-latest-Linux-x86_64.sh && \
    ln -s ../miniconda/bin/* /usr/local/bin/ && \
    apk del bash wget && \
    rm /var/cache/apk/*

#RUN /usr/glibc/usr/bin/ldconfig /lib /usr/local/miniconda/lib
ENV PATH /usr/local/miniconda/bin:$PATH
RUN conda install -y numpy libgcc freetype pyzmq swig scipy jupyter matplotlib requests ipykernel
RUN python -m ipykernel.kernelspec
RUN pip install https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.5.0-cp27-none-linux_x86_64.whl

ADD jupyter_notebook_config.py /root/.jupyter/
ADD run_jupyter.sh  /
EXPOSE 6006/tcp
EXPOSE 8888/tcp
CMD ["/bin/sh"]
