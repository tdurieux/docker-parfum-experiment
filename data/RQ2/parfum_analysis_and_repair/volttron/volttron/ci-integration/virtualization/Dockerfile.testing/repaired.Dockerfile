FROM volttron_test_base as test_core

WORKDIR ${VOLTTRON_ROOT}
USER $VOLTTRON_USER
RUN pwd
RUN python3 -m pip install --user -r ./ci-integration/virtualization/requirements_test.txt

RUN echo "export VOLTTRON_ROOT=${VOLTTRON_ROOT}" > /home/volttron/.bashrc && \
    echo "export VOLTTRON_USER_HOME=${VOLTTRON_USER_HOME}" >> /home/volttron/.bashrc && \
    echo "export IGNORE_ENV_CHECK=1" >> /home/volttron/.baschrc

USER root
WORKDIR ${VOLTTRON_ROOT}

RUN apt-get update

RUN apt-get install --no-install-recommends -y \
    sqlite3 && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    apt-utils && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
RUN apt-get update
RUN apt-get install --no-install-recommends docker-ce docker-ce-cli containerd.io -y && rm -rf /var/lib/apt/lists/*;

RUN usermod -aG docker $VOLTTRON_USER

ENTRYPOINT ["/startup/entrypoint.sh"]
