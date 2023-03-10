FROM centos:6

# add centos6 vault based repos
COPY centos6-repos/* /etc/yum.repos.d/

# use node 10 as it's guaranteed to run on CentOS6
RUN yum install -y centos-release-scl && \
    yum install -y devtoolset-7 python27 wget && \
    wget -q https://nodejs.org/dist/v10.23.0/node-v10.23.0-linux-x64.tar.gz && \
    tar -xf node-v10.23.0-linux-x64.tar.gz && \ 
    rm node-v10.23.0-linux-x64.tar.gz && \
    ln -s /node-v10.23.0-linux-x64/bin/node /bin/node && \
    ln -s /node-v10.23.0-linux-x64/bin/npm /bin/npm && rm -rf /var/cache/yum

# before building using this container you need to enable the right slc toolchain ie
# source /opt/rh/devtoolset-7/enable && source /opt/rh/python27/enable

