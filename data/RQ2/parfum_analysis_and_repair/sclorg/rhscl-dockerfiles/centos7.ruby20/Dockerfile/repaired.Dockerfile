FROM openshift/base-centos7

# This image provides a Ruby 2.0 environment you can use to run your Ruby
# applications.

MAINTAINER SoftwareCollections.org <sclorg@redhat.com>

EXPOSE 8080

ENV RUBY_VERSION 2.0

LABEL io.k8s.description="Platform for building and running Ruby 2.0 applications" \
      io.k8s.display-name="Ruby 2.0" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,ruby,ruby20"

RUN yum install -y \
    https://www.softwarecollections.org/en/scls/rhscl/v8314/epel-7-x86_64/download/rhscl-v8314-epel-7-x86_64.noarch.rpm \
    https://www.softwarecollections.org/en/scls/rhscl/ruby200/epel-7-x86_64/download/rhscl-ruby200-epel-7-x86_64.noarch.rpm \
    https://www.softwarecollections.org/en/scls/rhscl/ror40/epel-7-x86_64/download/rhscl-ror40-epel-7-x86_64.noarch.rpm \
    https://www.softwarecollections.org/en/scls/rhscl/nodejs010/epel-7-x86_64/download/rhscl-nodejs010-epel-7-x86_64.noarch.rpm && \
    yum install -y --setopt=tsflags=nodocs ruby200 ruby200-ruby-devel ruby200-rubygem-rake v8314 ror40-rubygem-bundler nodejs010 && \
    yum clean all -y && rm -rf /var/cache/yum

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# Each language image can have 'contrib' a directory with extra files needed to
# run and build the applications.
COPY ./contrib/ /opt/app-root

RUN chown -R 1001:0 /opt/app-root

USER 1001

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
