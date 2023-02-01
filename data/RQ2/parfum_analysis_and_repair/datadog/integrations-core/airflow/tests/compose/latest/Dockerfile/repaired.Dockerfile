FROM apache/airflow:latest
USER root
# INSTALL TOOLS
RUN apt-get update \
&& apt-get -y --no-install-recommends install libaio-dev \
&& apt-get install -y --no-install-recommends postgresql-client && rm -rf /var/lib/apt/lists/*;
RUN mkdir extra
USER airflow
# ENTRYPOINT SCRIPT
COPY ./init.sh ./init.sh
ENTRYPOINT ["./init.sh"]
