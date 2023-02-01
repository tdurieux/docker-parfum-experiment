# syntax=docker/dockerfile:1.1.3-experimental

######################################################################
# common setup
######################################################################
ARG SDK
FROM ${SDK} as tencentsdk
ARG ARCH
ARG TARGET
RUN mkdir -m 777 /tencent-sysroot
RUN --mount=target=/host --security=insecure /host/scripts/setup_host ${ARCH} ${TARGET}

FROM scratch AS tencentcache
ARG ARCH
ARG TOKEN
ARG PACKAGE
COPY --chown=1000:1000 --from=tencentsdk /tmp /cache
COPY --chown=1000:1000 .dockerignore /cache/.${PACKAGE}.${ARCH}.${TOKEN}

######################################################################
# package build
######################################################################
FROM tencentsdk AS tencentbuild
ARG ARCH
ARG TARGET
ARG PACKAGE
ARG ARCH2ARCH
ENV TARGET=${TARGET}
WORKDIR /home/builder

# setup rpm environment
USER builder
ENV PACKAGE=${PACKAGE} ARCH=${ARCH}
COPY --chown=builder ./etc/root.json ./rpmbuild/BUILD/root.json
COPY ./targets/${TARGET}/kernel_${ARCH}_config ./kernel_config
COPY ./etc/macro/${ARCH2ARCH} ./etc/macro/shared ./etc/macro/rust ./etc/macro/cargo ./packages/${PACKAGE}/ .

RUN rpmdev-setuptree && cat ${ARCH2ARCH} shared rust cargo > .rpmmacros && \
    echo "%_cross_variant ${TARGET}" >> .rpmmacros && echo "%_cross_repo_root_json %{_builddir}/root.json" >> .rpmmacros &&\
    rm -rf ${ARCH} shared rust cargo && mv *.spec rpmbuild/SPECS &&\
    find . -maxdepth 1 -not -path '*/\.*' -type f -exec mv {} rpmbuild/SOURCES/ \; &&\
    echo "rpmdev-setuptree done";

# install target-c-library
USER root
RUN --mount=target=/host \
    ln -s /host/build/${ARCH}-${TARGET}/packages/*.rpm ./rpmbuild/RPMS &&\
    createrepo_c -o ./rpmbuild/RPMS -x '*-debuginfo-*.rpm' -x '*-debugsource-*.rpm' --no-database /host/build/${ARCH}-${TARGET}/packages &&\
    repo2module  -s stable ./rpmbuild/RPMS modules.yaml &&\
    modifyrepo_c --mdtype=modules modules.yaml ./rpmbuild/RPMS/repodata/ && \
    cp .rpmmacros /etc/rpm/macros && \
    dnf -y --disablerepo '*' --repofrompath repo,./rpmbuild/RPMS --enablerepo 'repo' --nogpgcheck \
           --installroot /tencent-sysroot builddep rpmbuild/SPECS/${PACKAGE}.spec;

# build rpm package
USER builder
RUN mkdir -m 700 /home/builder/.ssh
RUN touch -m 600 /home/builder/.ssh/known_hosts
RUN ssh-keyscan git.woa.com > /home/builder/.ssh/known_hosts
RUN --mount=source=.cargo,target=/home/builder/.cargo \
    --mount=type=ssh,id=git_code,required=true,uid=1000,gid=1000 \
    --mount=type=cache,target=/home/builder/.cache,from=tencentcache,source=/cache \
    rpmbuild -ba --clean --nodeps rpmbuild/SPECS/${PACKAGE}.spec;

FROM scratch AS package
COPY --from=tencentbuild /home/builder/rpmbuild/RPMS/*/*.rpm /output/

######################################################################
# target build
######################################################################
FROM tencentsdk as tencentimage
ARG ARCH
ARG PACKAGES
ARG TARGET
ARG VERSION_ID
ARG IMAGE_NAME
ARG PRETTY_NAME
ARG KERNEL_VERSION
ENV KERNEL_VERSION=${KERNEL_VERSION}
ENV TARGET=${TARGET} VERSION_ID=${VERSION_ID} PRETTY_NAME=${PRETTY_NAME}
ENV PACKAGES=${PACKAGES} IMAGE_NAME=${IMAGE_NAME}

USER root
WORKDIR /root
# generate eks image