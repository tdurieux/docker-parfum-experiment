FROM ghcr.io/void-linux/void-linux:latest-full-x86_64-musl
%%%OS%%%
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV CI_NETWORK true
RUN echo fubar > /etc/machine-id
%%%INSTALL_DEPENDENCIES_COMMAND%%%
WORKDIR /github/workspace
CMD ["./contrib/ci/void.sh"]