ARG version
FROM centos:$version

RUN yum install -y \
        curl \
        ncurses-devel \
    && yum group install -y "Development Tools" && rm -rf /var/cache/yum

# Install Rust
ARG rustVersion
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=$rustVersion
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path \
    && chmod -R a+w $RUSTUP_HOME $CARGO_HOME

# Install AdoptOpenJDK 8
RUN echo $'[AdoptOpenJDK]\n\
name=AdoptOpenJDK\n\
baseurl=http://adoptopenjdk.jfrog.io/adoptopenjdk/rpm/centos/$releasever/$basearch\n\
enabled=1\n\
gpgcheck=1\n\
gpgkey=https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public\n'\
> /etc/yum.repos.d/adoptopenjdk.repo \
    && yum install adoptopenjdk-8-hotspot -y && rm -rf /var/cache/yum

WORKDIR /usr/src/paperd
CMD ["./release/targets/build_release.sh"]
