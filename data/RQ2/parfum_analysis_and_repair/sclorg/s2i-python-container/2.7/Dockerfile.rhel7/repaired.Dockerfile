# This image provides a Python 2.7 environment you can use to run your Python
# applications.
FROM rhscl/s2i-base-rhel7

EXPOSE 8080

ENV PYTHON_VERSION=2.7 \
    PYTHON_SCL_VERSION=27 \
    PATH=$PATH:/opt/rh/rh-python27/root/usr/bin:$HOME/.local/bin/:/opt/rh/$NODEJS_SCL/root/usr/bin:/opt/rh/httpd24/root/usr/bin:/opt/rh/python27/root/usr/bin:/opt/rh/httpd24/root/usr/sbin:/opt/rh/rh-python27/root/usr/local/bin \
    LD_LIBRARY_PATH=/opt/rh/rh-python27/root/usr/lib64:/opt/rh/$NODEJS_SCL/root/usr/lib64:/opt/rh/httpd24/root/usr/lib64:/opt/rh/python27/root/usr/lib64 \
    LIBRARY_PATH=/opt/rh/httpd24/root/usr/lib64 \
    X_SCLS=python27 \
    MANPATH=/opt/rh/rh-python27/root/usr/share/man:/opt/rh/python27/root/usr/share/man:/opt/rh/httpd24/root/usr/share/man:/opt/rh/$NODEJS_SCL/root/usr/share/man \
    VIRTUAL_ENV=/opt/app-root \
    PYTHONPATH=/opt/rh/$NODEJS_SCL/root/usr/lib/python2.7/site-packages \
    XDG_DATA_DIRS=/opt/rh/python27/root/usr/share:/opt/rh/rh-python27/root/usr/share:/usr/local/share:/usr/share \
    PKG_CONFIG_PATH=/opt/rh/python27/root/usr/lib64/pkgconfig:/opt/rh/httpd24/root/usr/lib64/pkgconfig:/opt/rh/rh-python27/root/usr/lib64/pkgconfig \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    CNB_STACK_ID=com.redhat.stacks.ubi7-python-27 \
    CNB_USER_ID=1001 \
    CNB_GROUP_ID=0 \
    PIP_NO_CACHE_DIR=off

ENV SUMMARY="Platform for building and running Python $PYTHON_VERSION applications" \
    DESCRIPTION="Python $PYTHON_VERSION available as container is a base platform for \
building and running various Python $PYTHON_VERSION applications and frameworks. \
Python is an easy to learn, powerful programming language. It has efficient high-level \
data structures and a simple but effective approach to object-oriented programming. \
Python's elegant syntax and dynamic typing, together with its interpreted nature, \
make it an ideal language for scripting and rapid application development in many areas \
on most platforms."

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="Python 2.7" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,python,python27,python-27,rh-python27" \
      com.redhat.component="python27-container" \
      name="rhscl/python-27-rhel7" \
      version="2.7" \
      usage="s2i build https://github.com/sclorg/s2i-python-container.git --context-dir=2.7/test/setup-test-app/ rhscl/python-27-rhel7 python-sample-app" \
      com.redhat.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI" \
      io.buildpacks.stack.id="com.redhat.stacks.ubi7-python-27" \
      maintainer="SoftwareCollections.org <sclorg@redhat.com>"

RUN INSTALL_PKGS="python27 python27-python-devel python27-python-setuptools python27-python-pip nss_wrapper \
        httpd24 httpd24-httpd-devel httpd24-mod_ssl httpd24-mod_auth_kerb httpd24-mod_ldap \
        httpd24-mod_session atlas-devel gcc-gfortran libffi-devel libtool-ltdl enchant" && \
    yum install -y yum-utils && \
    prepare-yum-repositories rhel-server-rhscl-7-rpms && \
    yum -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    # Remove redhat-logos (httpd dependency) to keep image size smaller.
    rpm -e --nodeps redhat-logos && \
    yum -y clean all --enablerepo='*' && rm -rf /var/cache/yum

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH.
COPY 2.7/s2i/bin/ $STI_SCRIPTS_PATH

# Copy extra files to the image.
COPY 2.7/root/ /

# - Create a Python virtual environment for use by any application to avoid
#   potential conflicts with Python packages preinstalled in the main Python
#   installation.
# - In order to drop the root user, we have to make some directories world
#   writable as OpenShift default security model is to run the container
#   under random UID.
RUN source scl_source enable python27 && \
    virtualenv ${APP_ROOT} && \
    rm -r /opt/wheels && \
    chown -R 1001:0 ${APP_ROOT} && \
    fix-permissions ${APP_ROOT} -P && \
    rpm-file-permissions


USER 1001

# Set the default CMD to print the usage of the language image.
CMD $STI_SCRIPTS_PATH/usage
