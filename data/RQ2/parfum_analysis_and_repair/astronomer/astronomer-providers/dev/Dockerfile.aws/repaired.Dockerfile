ARG IMAGE_NAME
FROM ${IMAGE_NAME}

USER root
RUN apt-get update -y && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends \
        build-essential \
        libsasl2-2 \
        libsasl2-dev \
        libsasl2-modules \
        unzip && rm -rf /var/lib/apt/lists/*;

# install AWS CLI
RUN curl -f "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install;

COPY setup.cfg ${AIRFLOW_HOME}/astronomer_providers/setup.cfg
COPY pyproject.toml ${AIRFLOW_HOME}/astronomer_providers/pyproject.toml

RUN pip install --no-cache-dir -e "${AIRFLOW_HOME}/astronomer_providers[all,tests,mypy]"
USER astro
