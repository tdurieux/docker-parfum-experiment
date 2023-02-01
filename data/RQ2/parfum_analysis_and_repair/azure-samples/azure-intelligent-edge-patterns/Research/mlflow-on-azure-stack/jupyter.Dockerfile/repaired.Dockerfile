FROM jupyter/datascience-notebook:latest

USER root

RUN apt-get -yq update && \
     apt-get -yqq --no-install-recommends install ssh && rm -rf /var/lib/apt/lists/*;

USER jovyan

RUN pip install --no-cache-dir pysftp

ADD ./jupyter-entrypoint.sh .

ENV SFTP_HOST=sftp.mlflow
ENV NB_PREFIX /

ENTRYPOINT [ "./jupyter-entrypoint.sh" ]