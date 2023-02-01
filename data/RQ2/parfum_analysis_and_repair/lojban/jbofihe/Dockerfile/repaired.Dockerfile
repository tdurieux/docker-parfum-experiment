FROM fedora:33

# Actual jbofihe build needs
RUN yum -y install flex bison gcc perl && rm -rf /var/cache/yum
# Packaging
RUN yum -y install ruby-devel gcc make rpm-build libffi-devel && rm -rf /var/cache/yum
RUN gem install --no-document fpm
