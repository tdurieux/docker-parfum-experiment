FROM terraref/terrautils:1.4
MAINTAINER Max Burnette <mburnet2@illinois.edu>

RUN apt-get -y update \
    && apt-get -y --no-install-recommends install curl \
    && pip install --no-cache-dir flask-restful \
        flask_wtf \
        python-logstash \
        psycopg2 \
        pandas && rm -rf /var/lib/apt/lists/*;

COPY *.py *.json /home/filecounter/
COPY templates /home/filecounter/templates

CMD ["python", "/home/filecounter/filecounter.py"]
