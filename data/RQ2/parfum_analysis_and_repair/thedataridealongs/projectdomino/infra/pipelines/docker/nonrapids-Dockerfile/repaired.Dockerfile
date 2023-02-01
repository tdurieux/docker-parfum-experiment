FROM python:3.7
RUN apt-get update \
    && apt-get install -y --no-install-recommends supervisor \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY . .
RUN pip install --no-cache-dir prefect==0.10.1 simplejson twarc neo4j boto3==1.12.39 \
    pandas git+https://github.com/twintproject/twint.git@origin/master#egg=twint \
&& ( prefect agent install local > supervisord.conf )
RUN prefect backend server
RUN ["chmod","+x","./infra/pipelines/docker/nonrapids-entrypoint.sh"]
CMD ["./infra/pipelines/docker/nonrapids-entrypoint.sh"]
