FROM centos/s2i-base-centos7

# This image provides a Ruby environment you can use to run your Ruby
# applications.

EXPOSE 8080

ENV RUBY_MAJOR_VERSION=2 \
    RUBY_MINOR_VERSION=5

ENV RUBY_VERSION="${RUBY_MAJOR_VERSION}.${RUBY_MINOR_VERSION}" \
    RUBY_SCL_NAME_VERSION="${RUBY_MAJOR_VERSION}${RUBY_MINOR_VERSION}"

ENV RUBY_SCL="rh-ruby${RUBY_SCL_NAME_VERSION}" \
    IMAGE_NAME="centos/ruby-${RUBY_SCL_NAME_VERSION}-centos7" \
    SUMMARY="Platform for building and running Ruby $RUBY_VERSION applications" \
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
      io.openshift.tags="builder,ruby,ruby${RUBY_SCL_NAME_VERSION},${RUBY_SCL}" \
      com.redhat.component="${RUBY_SCL}-container" \
      name="${IMAGE_NAME}" \
      version="${RUBY_VERSION}" \
      usage="s2i build https://github.com/sclorg/s2i-ruby-container.git \
--context-dir=${RUBY_VERSION}/test/puma-test-app/ ${IMAGE_NAME} ruby-sample-app" \
      maintainer="SoftwareCollections.org <sclorg@redhat.com>"

RUN yum install -y centos-release-scl-rh && \
    yum-config-manager --add-repo https://cbs.centos.org/repos/sclo7-rh-ruby25-rh-candidate/x86_64/os/ && \
    echo gpgcheck=0 >> /etc/yum.repos.d/cbs.centos.org_repos_sclo7-rh-ruby25-rh-candidate_x86_64_os_.repo && \
    INSTALL_PKGS=" \
${RUBY_SCL} \
${RUBY_SCL}-ruby-devel \
${RUBY_SCL}-rubygem-rake \
${RUBY_SCL}-rubygem-bundler \
" && \
    yum install -y --setopt=tsflags=nodocs ${INSTALL_PKGS} && \
    yum clean all -y && \
    rpm -V ${INSTALL_PKGS}

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
