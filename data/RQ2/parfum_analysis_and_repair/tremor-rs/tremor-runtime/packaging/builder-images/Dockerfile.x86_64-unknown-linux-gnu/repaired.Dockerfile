# https://hub.docker.com/_/centos
FROM centos:7.9.2009

# install extra software repos
RUN yum install --assumeyes \
    centos-release-scl `# provides devtoolset-9*` \
    epel-release `# provides deps like cmake3 and clang` && rm -rf /var/cache/yum

# get gcc9 via devtoolset-9, since gcc4 available from centos7 repos does not
# work for compiling our dependencies like snmalloc
# https://access.redhat.com/documentation/en-us/red_hat_developer_toolset/9/html/9.0_release_notes/dts9.0_release
RUN yum install --assumeyes devtoolset-9-gcc devtoolset-9-gcc-c++ make && rm -rf /var/cache/yum

# install cmake3 and link it as cmake (cmake >=3.8.2 needed for snmalloc)
RUN yum install --assumeyes cmake3 \
    && ln -s /usr/bin/cmake3 /usr/bin/cmake && rm -rf /var/cache/yum

# install other system deps
RUN yum install --assumeyes \
    llvm-toolset-7.0 `# for onig_sys (via the regex crate)` \
    devtoolset-9-libatomic-devel `# for snmalloc` \
    openssl-devel `# for dynamically linking against libssl1.0 (as part of openssl crate)` \
    perl `# for compiling & statically linking openssl (as part of openssl crate's vendored feature)` && rm -rf /var/cache/yum

# for dynamically linking against libssl1.1 (as part of openssl crate)
# centos7 has libssl1.0 by default and 1.1 is only available from epel
#RUN yum install --assumeyes openssl11-devel
## set variables utilized by rust openssl crate so that it knows to link against
## libssl1.1 (default in centos7 is libssl1.0)
## https://docs.rs/openssl/*/openssl/#manual
#ENV OPENSSL_INCLUDE_DIR=/usr/include/openssl11 \
#    OPENSSL_LIB_DIR=/usr/lib64/openssl11

# claim back some space
RUN yum clean all

# install rust
# this is not needed right now since we are using this image from cross and
# it already shares rust from the host to the image container. also saves us
# from needing to update this image to keep up with rust version releases.
#
# TODO the cargo bin path is also not readable by cross docker user
#ARG RUST_VERSION
#RUN curl --tlsv1.2 -sSf https://sh.rustup.rs -o rustup-init.sh \
#    && sh rustup-init.sh -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION \
#    && rm rustup-init.sh
#ENV PATH="/root/.cargo/bin:${PATH}"

COPY shared/entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
