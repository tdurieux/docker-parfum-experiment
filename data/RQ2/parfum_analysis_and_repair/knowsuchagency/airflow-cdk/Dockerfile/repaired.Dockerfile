FROM amazonlinux

RUN yum groupinstall -y "Development Tools"

RUN yum install -y python3-devel && rm -rf /var/cache/yum

RUN pip3 install --no-cache-dir -U pip

ARG REQUIREMENTS

ENV REQUIREMENTS \
    apache-airflow[postgres,celery,aws,gcp,crypto,password]>=1.10.10 \
    invoke

RUN pip3 install --no-cache-dir $REQUIREMENTS

ENV AIRFLOW__CORE__DAGS_FOLDER /src/dags

WORKDIR /src

COPY airflow_cdk/dags ./dags

COPY airflow_cdk/tasks.py ./

ENTRYPOINT ["invoke"]

CMD ["webserver"]