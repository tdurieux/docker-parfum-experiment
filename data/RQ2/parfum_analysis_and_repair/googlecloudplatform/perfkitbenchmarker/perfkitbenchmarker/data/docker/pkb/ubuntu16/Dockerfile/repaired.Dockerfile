#Dockerfile to use with Docker provider

FROM ubuntu:xenial

RUN apt-get update && apt-get install --no-install-recommends -y ssh && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y sudo iputils-ping && rm -rf /var/lib/apt/lists/*;
RUN mkdir /var/run/sshd ;\
    mkdir /root/.ssh ;\
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd ;\
    sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config ;\
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config ;\
    echo "UseDNS no" | tee -a /etc/ssh/sshd_config ;\
    echo "MaxSessions 1000" | tee -a /etc/ssh/sshd_config1

# Set the locale
RUN apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
