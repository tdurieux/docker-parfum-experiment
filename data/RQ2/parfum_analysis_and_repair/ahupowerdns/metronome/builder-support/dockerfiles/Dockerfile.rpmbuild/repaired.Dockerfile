FROM dist-base as package-builder
RUN yum install -y rpm-build rpmdevtools /usr/bin/python3 && \
    yum groupinstall -y "Development Tools" && \
    rpmdev-setuptree && rm -rf /var/cache/yum

RUN mkdir /dist /metronome
WORKDIR /metronome
ADD builder/helpers/ /metronome/builder/helpers/
# Used for -p option to only build specific spec files
ARG BUILDER_PACKAGE_MATCH

ARG BUILDER_VERSION
ARG BUILDER_RELEASE

COPY --from=sdist /sdist /sdist
RUN for file in /sdist/* ; do ln -s $file /root/rpmbuild/SOURCES/ ; done && ls /root/rpmbuild/SOURCES/
ADD builder-support/specfiles/ /metronome/builder-support/specfiles
RUN find /metronome/builder-support/specfiles/ -not -name '*.spec' -exec ln -s {} /root/rpmbuild/SOURCES/ \;

RUN builder/helpers/build-specs.sh builder-support/specfiles/metronome.spec

RUN cp -R /root/rpmbuild/RPMS/* /dist/
RUN cp -R /root/rpmbuild/SRPMS/* /dist/
