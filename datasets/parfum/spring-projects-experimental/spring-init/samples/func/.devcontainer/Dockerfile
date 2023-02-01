FROM springci/spring-graalvm-native:master-java8

ARG USER
ARG USER_ID
ARG USER_GID
ARG DOCKER_GID=130

RUN (groupadd --gid "${USER_GID}" "${USER}" || echo "No groupadd needed") && \
    useradd \
      --uid ${USER_ID} \
      --gid ${USER_GID} \
      --create-home \
      --shell /bin/bash ${USER} && \
      groupadd --gid $DOCKER_GID docker && \
      usermod -aG docker $USER

# Install Docker CE CLI
RUN apt-get update -y \
    && apt-get --fix-broken -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common lsb-release \
    && curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | apt-key add - 2>/dev/null \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" \
    && apt-get update -y \
    && apt-get install -y docker-ce-cli \
    && curl -sSL "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y

# Install psrecord and ab
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    python-setuptools python-dev python-pip python-tk \
    && pip install wheel psrecord matplotlib \
    && curl -sf https://gobinaries.com/rakyll/hey | sh

COPY main.py /usr/local/lib/python2.7/dist-packages/psrecord/
