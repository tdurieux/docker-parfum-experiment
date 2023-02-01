FROM registry.fedoraproject.org/f27/s2i-base:latest

# This image provides a Ruby environment you can use to run your Ruby
# applications.

EXPOSE 8080

ENV NAME=ruby \
    RUBY_VERSION=2.4 \
    RUBY_SHORT_VER=24 \
    VERSION=0

ENV SUMMARY="Platform for building and running Ruby $RUBY_VERSION applications" \
    DESCRIPTION="Ruby $RUBY_VERSION available as container is a base platform for \
building and running various Ruby $RUBY_VERSION applications and frameworks. \
Ruby is the interpreted scripting language for quick and easy object-oriented programming. \
It has many features to process text files and to do system management tasks (as in Perl). \
It is simple, straight-forward, and extensible."

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="Ruby ${RUBY_VERSION}" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,ruby,ruby${RUBY_SHORT_VER}" \
      com.redhat.component="$NAME" \
      name="$FGC/$NAME" \
      version="$VERSION" \
      usage="s2i build https://github.com/sclorg/s2i-ruby-container.git --context-dir=2.4/test/puma-test-app/ registry.fedoraproject.org/$FGC/ruby ruby-sample-app" \
      maintainer="SoftwareCollections.org <sclorg@redhat.com>"

# Install required packages
RUN INSTALL_PKGS="python2 ruby ruby-devel rubygem-bundler rubygem-rake rubygems-devel redhat-rpm-config" && \
    dnf install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    dnf clean all

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# Copy extra files to the image.
COPY ./root/ /

# Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:0 ${APP_ROOT} && chmod -R ug+rwx ${APP_ROOT} && \
    rpm-file-permissions

USER 1001

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
