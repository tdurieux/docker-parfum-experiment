# This Dockerfile is intended only for generating build bases necessary for testing Klever. Even though it deploys
# Klever partially, you can not use it for performing actual verification.

# Debian 9 is necessary to enable building of rather outdated versions of the Linux kernel. It does not prevent using
# generated build bases at verification on new versions of various Linux distributions.
FROM debian:9

ENV KLEVER_SRC_DIR /usr/src/klever/
ENV KLEVER_DEPLOY_DIR /usr/local/

ENV GCC_48_SRC_DIR build bases/gcc48/
ENV GCC_48_DEPLOY_DIR /usr/local/gcc48/
ENV LINUX_STABLE_SRC_DIR build bases/linux-stable/
ENV LINUX_STABLE_DEPLOY_DIR /usr/src/linux-stable/
ENV BUSYBOX_SRC_DIR build bases/busybox/
ENV BUSYBOX_DEPLOY_DIR /usr/src/busybox/
ENV BUILD_BASES_DIR /usr/src/build bases/

ENV WORK_DIR /usr/src/

# Copy GCC 4.8 binaries and Git repositories with the Linux kernel stable and BusyBox.
COPY $GCC_48_SRC_DIR $GCC_48_DEPLOY_DIR
COPY $LINUX_STABLE_SRC_DIR $LINUX_STABLE_DEPLOY_DIR
COPY $BUSYBOX_SRC_DIR $BUSYBOX_DEPLOY_DIR

# Install build-time dependencies for Klever, the Linux kernel and BusyBox.
RUN apt-get update \
    && apt-get install --no-install-recommends -y bc bison cmake flex gettext git graphviz libc6-dev-i386 libelf-dev libssl-dev make nginx \
               postgresql python3-dev python3-pip rabbitmq-server unzip wget && rm -rf /var/lib/apt/lists/*;
RUN wget -q https://forge.ispras.ru/attachments/download/7251/python-3.7.6.tar.xz
RUN tar -C / -xf python-3.7.6.tar.xz && rm python-3.7.6.tar.xz

# Deploy semi-functional Klever. We need only some commands, e.g. klever-build, test cases and several addons.
COPY .git $KLEVER_SRC_DIR/.git
WORKDIR $KLEVER_SRC_DIR
RUN git checkout -q HEAD
RUN git checkout .
# We did not prepare Python 3.10 for Debian 9. Allow to use Python 3.7.
RUN sed -i s/3\.10/3\.7/ setup.py
# There is not Django 4+ for Python 3.7. It is not an issue since we are not going to run complete Klever.
RUN sed -i s/Django==4\.0\.3// setup.py
RUN sed -i s/Django==4\.0\.3// requirements.txt
RUN /usr/local/python3-klever/bin/python3 -m venv $KLEVER_SRC_DIR/venv
RUN $KLEVER_SRC_DIR/venv/bin/python -m pip install --upgrade pip wheel setuptools setuptools_scm
RUN $KLEVER_SRC_DIR/venv/bin/python -m pip install -r requirements.txt -e .
RUN $KLEVER_SRC_DIR/venv/bin/klever-deploy-local --deployment-directory $KLEVER_DEPLOY_DIR \
    --install-only-klever-addons install development

# Generate build bases.
WORKDIR $WORK_DIR
RUN mkdir -p "$BUILD_BASES_DIR/linux" "$BUILD_BASES_DIR/userspace"
RUN $KLEVER_SRC_DIR/venv/bin/klever-build \
    "linux/testing/common models/gcc63" \
    "linux/testing/environment model specifications/gcc63" \
    "linux/validation/bugs found by Klever" \
    "linux/validation/fixed bugs found by Klever" \
    "userspace/busybox applets sample"
ENV PATH="${GCC_48_DEPLOY_DIR}/bin:${PATH}"
RUN $KLEVER_SRC_DIR/venv/bin/klever-build \
    "linux/loadable kernel modules sample" \
    "linux/loadable kernel modules sample arm" \
    "linux/loadable kernel modules sample arm64" \
    "linux/testing/common models/gcc48" \
    "linux/testing/decomposition strategies" \
    "linux/testing/environment model specifications/gcc48" \
    "linux/testing/requirement specifications" \
    "linux/testing/verifiers" \
    "linux/validation/2014 stable branch bugs"
RUN tar -C "$BUILD_BASES_DIR" -cJf build-bases.tar.xz linux userspace && rm build-bases.tar.xz

# You can find the resulting archive with generated build bases in /usr/src/build-bases.tar.xz.
