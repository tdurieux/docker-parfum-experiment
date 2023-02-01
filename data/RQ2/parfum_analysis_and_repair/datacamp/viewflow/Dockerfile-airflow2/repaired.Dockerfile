FROM apache/airflow:2.1.1-python3.7

USER root
RUN apt-get update -yqq \
    && apt-get install --no-install-recommends -y libpq-dev \
    && apt-get install --no-install-recommends -y build-essential \
    && apt-get install --no-install-recommends -y vim \
    && apt-get install --no-install-recommends -y git \
    && apt-get install --no-install-recommends -y r-base \
    && Rscript -e "install.packages('DBI')" \
    && Rscript -e "install.packages('RPostgres')" \
    && Rscript -e "install.packages('rmarkdown')" \
    && Rscript -e "install.packages('dplyr')" && rm -rf /var/lib/apt/lists/*;


COPY ./requirements.txt /requirements.txt
COPY ./viewflow /viewflow/viewflow
COPY ./pyproject.toml /viewflow/
COPY ./README.md /viewflow/

USER airflow

ENV PYTHONPATH /viewflow
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir /viewflow
