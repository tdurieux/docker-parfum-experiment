# Copyright (c) 2022 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#
# Contributors:
#   Red Hat, Inc. - initial API and implementation

# https://access.redhat.com/containers/?tab=tags#/registry.access.redhat.com/ubi8-minimal
FROM ubi8-minimal:8.6-854

USER root

ENV \
    HOME=/home/user \
    KAMEL_VERSION="" \
    ODO_VERSION="v2.5.0" \
    NODEJS_VERSION="16" \
    GRADLE_VERSION="6.1" \
    MAVEN_VERSION="3.6.3" \
    LOMBOK_VERSION="1.18.22" \
    PYTHON_VERSION="3.8" \
    PHP_VERSION="7.3" \
    E2FSPROGS_VERSION="1.46.5" \
    LD_LIBRARY_PATH="/usr/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" \
    CPATH="/usr/include${CPATH:+:${CPATH}}" \
    DOTNET_RPM_VERSION=3.1 \
    DOTNET_CLI_TELEMETRY_OPTOUT=1 \
    JAVA11_HOME=/usr/lib/jvm/java-11-openjdk \
    JAVA8_HOME=/usr/lib/jvm/java-1.8.0-openjdk \
    JAVA_HOME="/home/user/.java/current" \
    PATH="/home/user/.java/current/bin:/home/user/node_modules/.bin/:/home/user/.npm-global/bin/:/opt/app-root/src/.npm-global/bin/:/opt/apache-maven/bin:/opt/gradle/bin:/usr/bin:${PATH:-/bin:/usr/bin}" \
    MANPATH="/usr/share/man:${MANPATH}" \
    JAVACONFDIRS="/etc/java${JAVACONFDIRS:+:}${JAVACONFDIRS:-}" \
    XDG_CONFIG_DIRS="/etc/xdg:${XDG_CONFIG_DIRS:-/etc/xdg}" \
    XDG_DATA_DIRS="/usr/share:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}" \
    M2_HOME="/opt/apache-maven" \
    PKG_CONFIG_PATH="/usr/lib64/pkgconfig${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}" \
    GOPATH=/projects/.che/gopath

ADD etc/storage.conf $HOME/.config/containers/storage.conf

RUN mkdir -p /home/user /projects

COPY . /tmp/assets/
COPY etc/docker.sh /usr/local/bin/docker
COPY lombok-${LOMBOK_VERSION}.jar /lombok.jar
COPY gradle-${GRADLE_VERSION}-bin.zip apache-maven-${MAVEN_VERSION}-bin.tar.gz e2fsprogs-${E2FSPROGS_VERSION}.tar.gz /tmp/

# NOTE: uncomment for local build. Must also set full registry path in FROM to registry.redhat.io or registry.access.redhat.com
# enable rhel 8 content sets (from Brew) to resolve buildah
# COPY content_set*.repo /etc/yum.repos.d/

    ########################################################################
    # Common Installations and Configuration
    ########################################################################
RUN \
    microdnf install -y dnf bash tar gzip unzip bzip2 which shadow-utils findutils wget curl sudo git procps-ng podman skopeo \
    # For OpenShift Client 4 (oc): rhocp-4.9-for-rhel-8-x86_64-rpms
    # must hard code a version because otherwise CVP/Brew fails with: Failed component comparison for components: openshift-clients
    # http://rhsm-pulp.corp.redhat.com/content/dist/layered/rhel8/x86_64/ocp/tools/4.8/os/Packages/h/helm-3.6.2-5.el8.x86_64.rpm
    # http://rhsm-pulp.corp.redhat.com/content/dist/layered/rhel8/s390x/ocp/tools/4.8/os/Packages/h/helm-3.6.2-5.el8.s390x.rpm
    # http://rhsm-pulp.corp.redhat.com/content/dist/layered/rhel8/ppc64le/ocp/tools/4.8/os/Packages/h/helm-3.6.2-5.el8.ppc64le.rpm
    # http://rhsm-pulp.corp.redhat.com/content/dist/layered/rhel8/x86_64/rhocp/4.9/os/Packages/o/openshift-clients-4.9.0-202206240935.p0.g728b452.assembly.stream.el8.x86_64.rpm
    # http://rhsm-pulp.corp.redhat.com/content/dist/layered/rhel8/s390x/rhocp/4.9/os/Packages/o/openshift-clients-4.9.0-202206240935.p0.g728b452.assembly.stream.el8.s390x.rpm
    # http://rhsm-pulp.corp.redhat.com/content/dist/layered/rhel8/ppc64le/rhocp/4.9/os/Packages/o/openshift-clients-4.9.0-202206240935.p0.g728b452.assembly.stream.el8.ppc64le.rpm
    buildah helm-3.6.2-5.el8 openshift-clients-4.9.0-202206240935.p0.g728b452.assembly.stream.el8 && \
    mkdir -p /opt && \
    # Change permissions to let any arbitrary user
    for f in "${HOME}" "/etc/passwd" "/etc/group" "/projects"; do \
        echo "Changing permissions on ${f}" && chgrp -R 0 ${f} && \
        chmod -R g+rwX ${f}; \
    done && \
    # add user and configure it
    useradd -u 1000 -G wheel,root -d /home/user --shell /bin/bash -m user && \
    # Generate passwd.template
    cat /etc/passwd | \
    sed s#user:x.*#user:x:\${USER_ID}:\${GROUP_ID}::\${HOME}:/bin/bash#g \
    > ${HOME}/passwd.template && \
    cat /etc/group | \
    sed s#root:x:0:#root:x:0:0,\${USER_ID}:#g \
    > ${HOME}/group.template
RUN \



    dnf -y -q install java-1.8.0-openjdk java-1.8.0-openjdk-devel java-1.8.0-openjdk-headless \
    java-11-openjdk java-11-openjdk-devel java-11-openjdk-src java-11-openjdk-headless && \
    mkdir -p ${HOME}/.java/current && \
    rm -f /usr/bin/java && \
    ln -s /usr/lib/jvm/java-11-openjdk/* ${HOME}/.java/current && \
    ########################################################################
    # nodejs
    ########################################################################
    # BEGIN copy from https://catalog.redhat.com/software/containers/ubi8/nodejs-16/615aee9fc739c0a4123a87e1?container-tabs=dockerfile
    dnf -y -q module enable nodejs:$NODEJS_VERSION && \
    MODULE_DEPS="make gcc gcc-c++ libatomic_ops git openssl-devel" && \
    INSTALL_PKGS="$MODULE_DEPS nodejs npm nodejs-nodemon nss_wrapper" && \
    ln -s /usr/lib/node_modules/nodemon/bin/nodemon.js /usr/bin/nodemon && \
    ln -s /usr/libexec/platform-python /usr/bin/python3 && \
    dnf -y -q install --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    # END copy from https://catalog.redhat.com/software/containers/ubi8/nodejs-16/615aee9fc739c0a4123a87e1?container-tabs=dockerfile
    ########################################################################
    # Gradle
    ########################################################################
    # unpack gradle into /opt/gradle/, and maven into /opt/apache-maven/
    mkdir -p /opt; unzip -d /opt /tmp/gradle-${GRADLE_VERSION}-bin.zip && \
    mv /opt/gradle-${GRADLE_VERSION} /opt/gradle && rm -f /tmp/gradle-${GRADLE_VERSION}-bin.zip && \
    ########################################################################
    # Maven
    ########################################################################
    tar xzf /tmp/assets/apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /opt && \
    mv /opt/apache-maven-${MAVEN_VERSION} /opt/apache-maven && \
    rm -f /tmp/assets/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    # fix permissions in bin/* files
    for d in $(find /opt/apache-maven -name bin -type d); do echo $d; chmod +x $d/*; done && \
    # additional node stuff
    mkdir -p /opt/app-root/src/.npm-global/bin && \
    ln -s /usr/bin/node /usr/bin/nodejs && \
    for f in "/opt/app-root/src/.npm-global"; do chgrp -R 0 ${f}; chmod -R g+rwX ${f}; done && \
    ########################################################################
    # Python
    ########################################################################
    # BEGIN update to python 3.8 per https://catalog.redhat.com/software/containers/ubi8/python-38/5dde9cacbed8bd164a0af24a?container-tabs=dockerfile
    dnf -y -q module reset python38 && \
    dnf -y -q module enable python38:${PYTHON_VERSION} && \
    dnf -y -q install python38 python38-devel python38-setuptools python38-pip && \
    # END update to python 3.8 per https://catalog.redhat.com/software/containers/ubi8/python-38/5dde9cacbed8bd164a0af24a?container-tabs=dockerfile
    # python lang server
    mkdir -p /tmp/py-unpack && tar -xf /tmp/assets/asset-python-ls-$(uname -m).tar.gz -C /tmp/py-unpack && \
    for f in /tmp/py-unpack; do chgrp -R 0 ${f}; chmod -R g+rwX ${f}; done; rm /tmp/assets/asset-python-ls-$( uname -m).tar.gz \
    for d in bin lib lib64; do cp -R /tmp/py-unpack/${d}/* /usr/${d}; done; \
    cp -R /tmp/py-unpack/.venv ${HOME} && chgrp -R 0 ${HOME}/.venv && chmod -R g+rwX ${HOME}/.venv && \
    rm -fr /tmp/py-unpack
RUN \
    # python/pip/pylint symlinks
    echo "Create python symlinks (or display existing ones) ==>" && \
    echo -e "#/usr/bin/bash\n/usr/bin/python${PYTHON_VERSION} -m pylint \$*" | sed -r -e "s@#@#\!@" > /usr/bin/pylint && \
    echo -e "#/usr/bin/bash\n/usr/bin/python${PYTHON_VERSION} -m pylint \$*" | sed -r -e "s@#@#\!@" > /usr/bin/pylint${PYTHON_VERSION} && \
    chmod +x /usr/bin/pylint* && \
    SL=/usr/local/bin/python; if [[ ! -f ${SL} ]] && [[ ! -L ${SL} ]]; then ln -s /usr/bin/python${PYTHON_VERSION} ${SL}; else ls -la ${SL}; fi && \
    SL=/usr/local/bin/pip; if [[ ! -f ${SL} ]] && [[ ! -L ${SL} ]]; then ln -s /usr/bin/pip${PYTHON_VERSION} ${SL}; else ls -la ${SL}; fi && \
    SL=/usr/local/bin/pylint; if [[ ! -f ${SL} ]] && [[ ! -L ${SL} ]]; then ln -s /usr/bin/pylint${PYTHON_VERSION} ${SL}; else ls -la ${SL}; fi && \
    echo "<== Create python symlinks (or display existing ones)"
RUN \
    ########################################################################
    # Kamel, ODO
    ########################################################################
    if [[ -f /usr/local/bin/kamel ]]; then rm -f /usr/local/bin/kamel; fi; \
    if [[ -f /tmp/assets/asset-kamel-$(uname -m).tar.gz ]]; then tar xzf /tmp/assets/asset-kamel-$(uname -m).tar.gz -C /usr/local/bin/; fi; \
    if [[ -f /usr/local/bin/odo ]]; then rm -f /usr/local/bin/odo; fi; \
    tar xzf /tmp/assets/asset-odo.tgz --strip=1 -C /usr/local/bin $(uname -m)/odo && rm -fr /tmp/assets/asset-odo.tgz
RUN \
    ########################################################################
    # C/C++ (Tech Preview)
    ########################################################################
    dnf -y -q install llvm-toolset clang clang-libs clang-tools-extra git-clang-format gdb make cmake gcc gcc-c++ && \
    # to see what requires kernel-headers, use in line above: dnf install --exclude=kernel*
    # or query: rpm -q --whatrequires kernel-headers && rpm -q --whatrequires glibc-headers && rpm -q --whatrequires glibc-devel && rpm -q --whatrequires gcc
    mkdir -p ${HOME}/che/ls-csharp ${HOME}/che/ls-clangd && \
    echo "clangd -pretty" > ${HOME}/che/ls-clangd/launch.sh && \
    chmod +x ${HOME}/che/ls-clangd/launch.sh
    ########################################################################
    # Dotnet (x64 only) (Tech Preview)
    ########################################################################
RUN \
    if [[ "$(uname -m)" == 'x86_64' ]]; then \
        dnf -y -q --setopt=tsflags=nodocs install dotnet dotnet-host dotnet-hostfxr-${DOTNET_RPM_VERSION} dotnet-runtime-${DOTNET_RPM_VERSION} dotnet-sdk-${DOTNET_RPM_VERSION}; \
    fi
RUN \



    dnf -y -q install golang glibc-devel zlib-devel libstdc++ libstdc++-devel && \
    mkdir -p /projects/.che/gopath /.cache ${HOME}/go && \
    tar -xvf /tmp/assets/asset-golang-$(uname -m).tar.gz --strip-components=1 -C /projects/.che/gopath/ && \
    for f in "/home/user" "/etc/passwd" "/etc/group" "/projects" "/.cache" "/usr/share/gocode" "/opt/app-root/src/"; do \
        chgrp -R 0 ${f} && \
        chmod -R g+rwX ${f}; \
    done && rm /tmp/assets/asset-golang-$( uname -m).tar.gz
RUN \



    dnf -y -q module enable php:$PHP_VERSION && \
    dnf -y -q install php php-fpm php-opcache php-devel php-pear php-gd php-mysqli php-zlib php-curl ca-certificates && \
    tar xzf /tmp/assets/asset-php-xdebug-$(uname -m).tar.gz -C / && \
    sed -i 's/opt\/app-root\/src/projects/' /etc/httpd/conf/httpd.conf && \
    sed -i 's/#DocumentRoot/DocumentRoot/' /etc/httpd/conf/httpd.conf && \
    sed -i 's/CustomLog \"|\/usr\/bin\/cat\"/CustomLog \"\/var\/log\/httpd\/access_log\"/' /etc/httpd/conf/httpd.conf && \
    sed -i 's/ErrorLog \"|\/usr\/bin\/cat\"/ErrorLog \"\/var\/log\/httpd\/error_log\"/' /etc/httpd/conf/httpd.conf && \
    chmod -R 777 /var/run/httpd /var/log/httpd/ /etc/pki/ /etc/httpd/logs/ && \
    mkdir -p ${HOME}/che/ls-php/php-language-server && \
    tar xzf /tmp/assets/asset-php-$(uname -m).tar.gz -C ${HOME}/che/ls-php/php-language-server/ && \
    cp ${HOME}/che/ls-php/php-language-server/composer/composer /usr/bin/composer && rm /tmp/assets/asset-php-xdebug-$( uname -m).tar.gz
RUN \
    ########################################################################
    # e2fsprogs (x64 only) (Tech Preview)
    ########################################################################
    if [[ "$(uname -m)" == 'x86_64' ]]; then \
        TEMP_DIR="$(mktemp -d)" && \
        cd "${TEMP_DIR}" && \
        mv /tmp/e2fsprogs-${E2FSPROGS_VERSION}.tar.gz . && \
        tar -zxvf e2fsprogs-${E2FSPROGS_VERSION}.tar.gz && \
        cd "e2fsprogs-${E2FSPROGS_VERSION}" && \
        mkdir build && \
        cd build && \
        ../configure --prefix=/usr --with-root-prefix="" --enable-elf-shlibs && \
        make && \
        make install && \
        make install-libs && \
        cd -- && \
        rm -rf "${TEMP_DIR}"; \
    else \
        rm /tmp/e2fsprogs-${E2FSPROGS_VERSION}.tar.gz; \
    fi
    ########################################################################
    # Cleanup and Summaries
    ########################################################################
RUN \
    # fetch CVE updates
    dnf -y -q update && \
    dnf -y -q clean all --enablerepo='*' && \
    dnf -y -q clean all && rm -rf /var/cache/yum && \
    rm -fr /tmp/assets/ && \
    chmod 755 /usr/local/bin/* && \
    chmod -R g+rwX ${HOME} && \
    echo "Installed Packages" && rpm -qa | sort -V && echo "End Of Installed Packages" && \
    echo "========" && \
    echo -n "java:  "; java -version; \
    echo -n "mvn:   "; mvn -version; \
    echo -n "gradle:    "; gradle -v; \
    echo "========" && \
    echo -n "node:  "; node --version; \
    echo -n "npm:   "; npm --version; \
    echo "========" && \
    echo "python basic install:"; python -V; \
    echo -n "pip:   "; pip -V; \
    echo -n "pylint:    "; pylint --version; \
    echo "========" && \
    echo "python venv install:"; python${PYTHON_VERSION} -m venv .venv && . .venv/bin/activate; python -V; \
    echo -n "pip:   "; pip -V; \
    echo -n "pylint:    "; pylint --version; \
    echo "========" && \
    echo -n "oc:    "; oc version; \
    echo -n "odo:    "; odo version; \
    echo -n "helm:    "; helm version --short --client; \
    echo -n "kubectl: "; kubectl version --short --client=true; \
    if [[ -f /usr/local/bin/kamel ]]; then \
      echo -n "kamel:   "; kamel version; \
    else \
      echo "kamel: not available on $(uname -m)"; \
    fi; \
    echo "========" && \
    echo -n "clangd:    "; clangd --version; \
    if [[ -f /usr/bin/dotnet ]]; then \
      echo -n "dotnet:    "; dotnet --version; \
    else \
      echo "dotnet: not available on $(uname -m)"; \
    fi; \
    echo -n "go:    "; go version; \
    echo -n "php:    "; php -v; \
    echo "========"

ADD etc/entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
WORKDIR /projects
CMD tail -f /dev/null

ENV SUMMARY="Red Hat OpenShift Dev Spaces - Universal Developer Image container" \
    DESCRIPTION="Red Hat OpenShift Dev Spaces - Universal Developer Image container" \
    PRODNAME="devspaces" \
    COMPNAME="udi-rhel8"

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="$DESCRIPTION" \
      io.openshift.tags="$PRODNAME,$COMPNAME" \
      com.redhat.component="$PRODNAME-$COMPNAME-container" \
      name="$PRODNAME/$COMPNAME" \
      version="3.2" \
      license="EPLv2" \
      maintainer="Nick Boldt <nboldt@redhat.com>" \
      io.openshift.expose-services="" \
      usage=""
