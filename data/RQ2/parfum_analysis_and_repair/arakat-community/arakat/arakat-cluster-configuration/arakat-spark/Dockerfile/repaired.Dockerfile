FROM bde2020/spark-master:2.3.2-hadoop2.8

RUN apt-get update && apt-get install --no-install-recommends -y python-pip && apt-get install --no-install-recommends -y kafkacat && rm -rf /var/lib/apt/lists/*;

ENV PATH="/spark/bin:${PATH}"

COPY requirements.txt /

RUN pip install --no-cache-dir -r /requirements.txt

COPY SparkOperator.py /
COPY master.sh /
COPY script.py /

RUN mkdir /spark_logs

EXPOSE 5000 8080 7077 6066

CMD ["/bin/bash", "/master.sh"]
