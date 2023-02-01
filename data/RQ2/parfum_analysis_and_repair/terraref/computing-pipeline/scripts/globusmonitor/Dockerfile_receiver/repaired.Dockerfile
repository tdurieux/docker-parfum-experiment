FROM terraref/terrautils:1.2
MAINTAINER Max Burnette <mburnet2@illinois.edu>

RUN apt-get -y update \
    && apt-get -y --no-install-recommends install curl \
    && pip install --no-cache-dir flask-restful \
        python-logstash \
        globusonline-transfer-api-client \
        psycopg2 && rm -rf /var/lib/apt/lists/*;

COPY *.py *.json *.pem /home/globusmonitor/

ENV MONITOR_API_PORT 5454
CMD ["python", "/home/globusmonitor/globus_monitor_service.py"]
