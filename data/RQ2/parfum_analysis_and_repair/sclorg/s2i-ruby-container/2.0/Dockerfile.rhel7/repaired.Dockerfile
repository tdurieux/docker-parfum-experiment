FROM openshift/base-rhel7

# This image provides a Ruby 2.0 environment you can use to run your Ruby
# applications.

EXPOSE 8080

ENV RUBY_VERSION 2.0

LABEL summary="Platform for building and running Ruby 2.0 applications" \
      io.k8s.description="Platform for building and running Ruby 2.0 applications" \
      io.k8s.display-name="Ruby 2.0" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,ruby,ruby20"

# Labels consumed by Red Hat build service
LABEL com.redhat.component="openshift-sti-ruby-docker" \
      name="openshift3/ruby-20-rhel7" \
      version="2.0" \
      release="2" \
      architecture="x86_64"

# To use subscription inside container yum command has to be run first (before yum-config-manager)
# https://access.redhat.com/solutions/1443553
RUN yum repolist > /dev/null && \
    yum-config-manager --enable rhel-server-rhscl-7-rpms && \
    yum-config-manager --enable rhel-7-server-optional-rpms && \
    INSTALL_PKGS="ruby200 ruby200-ruby-devel ruby200-rubygem-rake v8314 ror40-rubygem-bundler nodejs010" && \
    yum install -y --setopt=tsflags=nodocs  $INSTALL_PKGS && rpm -V $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*' && rm -rf /var/cache/yum

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# Copy extra files to the image.
COPY ./root/ /

RUN chown -R 1001:0 /opt/app-root && chmod -R ug+rwx /opt/app-root

USER 1001

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
