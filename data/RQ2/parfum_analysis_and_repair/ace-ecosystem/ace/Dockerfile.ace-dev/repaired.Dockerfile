FROM ace-base:latest
USER root
RUN apt-get -y --no-install-recommends install git vim screen default-mysql-client man htop net-tools ctags strace && rm -rf /var/lib/apt/lists/*;
RUN rmdir /opt/signatures && ln -s /opt/ace/etc/yara /opt/signatures
USER ace
WORKDIR /opt/ace
VOLUME [ "/opt/ace", "/opt/ace/data", "/home/ace" ]
EXPOSE 5000
