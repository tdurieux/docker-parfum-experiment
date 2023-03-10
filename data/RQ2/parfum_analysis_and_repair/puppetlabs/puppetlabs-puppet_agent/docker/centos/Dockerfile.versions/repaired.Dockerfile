FROM centos:8

# Install some other dependencies for ease of life.
RUN yum update -y \
  && yum install -y wget git \
  && yum clean all && rm -rf /var/cache/yum

# Install several repos: PC1 (puppet 4), puppet 5, puppet 6, and puppet7.
RUN wget -O puppet-pc1.rpm https://yum.puppet.com/puppetlabs-release-pc1-el-7.noarch.rpm && \
    rpm -i puppet-pc1.rpm --force --replacefiles && \
    wget -O puppet5.rpm https://yum.puppet.com/puppet5-release-el-7.noarch.rpm && \
    rpm -i puppet5.rpm --force --replacefiles && \
    wget -O puppet6.rpm https://yum.puppet.com/puppet6-release-el-7.noarch.rpm && \
    rpm -i puppet6.rpm --force --replacefiles --nodeps && \
    wget -O puppet7.rpm https://yum.puppet.com/puppet7-release-el-7.noarch.rpm && \
    rpm -i puppet7.rpm --force --replacefiles --nodeps

# Print out available package versions for puppet-agent. If a specific version
# is desired, pass that in with e.g. `--build-arg before=1.1.1`
ENTRYPOINT ["yum", "list", "puppet-agent", "--showduplicates"]