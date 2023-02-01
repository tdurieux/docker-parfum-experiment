FROM debian:bullseye AS build
MAINTAINER Astronomer DAG Authoring Team <airflow_dag_authors@astronomer.io>

ARG GIT_HASH=""
LABEL git_hash=${GIT_HASH}

# Set default environment variables
# These will be overridden by K8s if declared eg. by using ConfigMaps.
#ENV SDK_DEPENDENCIES=/tmp/
ENV AIRFLOW_HOME=/opt/app/
ENV PYTHONPATH=/opt/app/
ENV ASTRO_PUBLISH_BENCHMARK_DATA=True
ENV GCP_BUCKET=dag-authoring

# Debian Bullseye is shipped with Python 3.9
# Upgrade built-in pip
RUN apt-get update
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;

# Install the Google SDK
RUN apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install --no-install-recommends google-cloud-cli -y && rm -rf /var/lib/apt/lists/*;

# Install Astro SDK dependencies

COPY . .
# We need to update pip as only newer versions of pip allow installing in edit mode for pyproject.toml projects. For more info: https://peps.python.org/pep-0660/
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -e .[all]


FROM build AS benchmark
ENV AIRFLOW_HOME=/opt/app/
ENV PYTHONPATH=/opt/app/
ENV AIRFLOW__CORE__ENABLE_XCOM_PICKLING=True


RUN mkdir -p $AIRFLOW_HOME
WORKDIR $AIRFLOW_HOME
COPY . .


COPY tests/benchmark/dags $AIRFLOW_HOME/dags
COPY tests/benchmark/run.sh $AIRFLOW_HOME/
COPY tests/benchmark/run.py $AIRFLOW_HOME/
COPY tests/benchmark/config.json $AIRFLOW_HOME/config.json

# Debian Bullseye is shipped with Python 3.9
# Upgrade built-in pip
RUN apt-get update
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;

# Install the Google SDK
RUN apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install --no-install-recommends google-cloud-cli -y && rm -rf /var/lib/apt/lists/*;

WORKDIR ./tests/benchmark/

CMD ./run.sh
