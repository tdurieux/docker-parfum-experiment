FROM centos:8
RUN dnf install -y gcc-c++ boost-devel \
    && rm -rf /var/cache/{yum,dnf}/* \
    && dnf clean all
COPY config.compile.json /config.json
COPY penguin_judge_agent /bin
CMD ["/bin/penguin_judge_agent"]