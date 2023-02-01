ARG IMAGE_NAME
FROM ${IMAGE_NAME}

USER root
RUN apt-get update -y && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends \
        build-essential \
        libsasl2-2 \
        libsasl2-dev \
        libsasl2-modules && rm -rf /var/lib/apt/lists/*;

COPY setup.cfg ${AIRFLOW_HOME}/astronomer_providers/setup.cfg
COPY pyproject.toml ${AIRFLOW_HOME}/astronomer_providers/pyproject.toml


RUN pip install --no-cache-dir -e "${AIRFLOW_HOME}/astronomer_providers[all,tests,mypy]"
USER astro
