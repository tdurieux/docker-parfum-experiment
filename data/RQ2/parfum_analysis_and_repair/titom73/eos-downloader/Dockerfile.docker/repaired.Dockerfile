ARG PYTHON_VER=3.8

FROM python:${PYTHON_VER}-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
        curl \
        gnupg \
        lsb-release \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
        gpg --batch --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
        $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y --no-install-recommends docker-ce-cli \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean

RUN pip install --no-cache-dir --upgrade pip

WORKDIR /local
COPY . /local

LABEL maintainer="Thomas Grimonet <tom@inetsix.net>"
LABEL com.example.version="edge"
LABEL com.example.release-date="2022-04-05"
LABEL com.example.version.is-production="False"

RUN pip install --no-cache-dir .

CMD [ "/usr/local/bin/eos-download" ]