FROM ubuntu:18.04
# FROM uptodate

RUN apt-get update && apt-get install --no-install-recommends -y openssh-server net-tools telnet && rm -rf /var/lib/apt/lists/*;
RUN mkdir /var/run/sshd
RUN mkdir /twister2-volatile
RUN mkdir -p /twister2/persistent

# Set root password Change it
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile


# Create ssh key via ssh-keygen copy that files to .ssh folder
RUN mkdir /root/.ssh
ADD id_rsa /root/.ssh/id_rsa
ADD id_rsa.pub /root/.ssh/authorized_keys

# Install OpenJDK-8
RUN apt-get update && \
    apt-get install --no-install-recommends -y openjdk-8-jdk && \
    apt-get install --no-install-recommends -y ant && \
    apt-get clean; rm -rf /var/lib/apt/lists/*;

# Fix certificate issues
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates-java && \
    apt-get clean && \
    apt-get install --no-install-recommends -y curl && \
    update-ca-certificates -f; rm -rf /var/lib/apt/lists/*;

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

# Disable prompts from apt.
ENV DEBIAN_FRONTEND noninteractive


# install ssh and basic dependencies
RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
    locales wget ca-certificates ssh build-essential && \
    apt-get install --no-install-recommends -y g++ && \
    apt-get install --no-install-recommends -y maven && \
    apt-get clean && apt-get purge && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*


#openmpi install
RUN wget https://www.open-mpi.org/software/ompi/v3.0/downloads/openmpi-3.0.0.tar.gz
RUN tar -zxvf openmpi-3.0.0.tar.gz -C / && rm openmpi-3.0.0.tar.gz
ENV OMPI_BUILD="/openmpi-build"
ENV OMPI_300="/openmpi-3.0.0"
ENV PATH="${OMPI_BUILD}/bin:${PATH}"
ENV LD_LIBRARY_PATH="${OMPI_BUILD}/lib:${LD_LIBRARY_PATH}"
RUN export OMPI_BUILD OMPI_300 PATH LD_LIBRARY_PATH
RUN cd /openmpi-3.0.0 && ls -la && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=$OMPI_BUILD --enable-mpi-java --enable-mpirun-prefix-by-default --enable-orterun-prefix-by-default && make; make install
RUN rm openmpi-3.0.0.tar.gz

COPY rootfs /
COPY rootfs/sshd_config /etc/ssh/
RUN chmod 777 /etc/ssh/sshd_config

EXPOSE 2022 2023 30000 30001 30002 30003 30004 30005 30006 30007 30008 30009 30010
#CMD ["/usr/sbin/sshd", "-D"]
CMD ["/init.sh"]
COPY rootfs/config /root/.ssh/


# https://docs.docker.com/engine/examples/running_ssh_service/#build-an-eg_sshd-image
