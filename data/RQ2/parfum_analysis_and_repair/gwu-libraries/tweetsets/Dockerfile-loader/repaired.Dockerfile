FROM python:3.8-buster
MAINTAINER TweetSets <sfm@gwu.edu>

ADD requirements.txt /opt/tweetsets/
WORKDIR /opt/tweetsets
RUN pip install --no-cache-dir -r requirements.txt
RUN grep elasticsearch requirements.txt | xargs pip install -t dependencies

RUN apt-get update && \
    apt-get install --no-install-recommends -y openjdk-11-jre-headless \
    ca-certificates-java \
    zip -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt/tweetsets/dependencies
RUN zip -r ../dependencies.zip .
WORKDIR /opt/tweetsets

ADD tweetset_loader.py /opt/tweetsets/
ADD models.py /opt/tweetsets/
ADD utils.py /opt/tweetsets/
ADD spark_utils.py /opt/tweetsets/
ADD tweetsets_schema.json /opt/tweetsets/
ADD tweetsets_sql_exp.sql /opt/tweetsets/
ADD tests/spark/ /opt/tweetsets/tests
ADD tests/spark/_test_spark_loader.py /opt/tweetsets/tests/test_spark_loader.py
ADD setup.py /opt/tweetsets/
ADD elasticsearch-spark-30_2.12-7.13.4.jar /opt/tweetsets/elasticsearch-hadoop.jar
ADD tweetset_cli.py /opt/tweetsets/

RUN python setup.py bdist_egg

ENV SPARK_LOCAL_IP 0.0.0.0
ENV SPARK_DRIVER_PORT 5001
ENV SPARK_UI_PORT 5002
ENV SPARK_BLOCKMGR_PORT 5003
EXPOSE $SPARK_DRIVER_PORT $SPARK_UI_PORT $SPARK_BLOCKMGR_PORT

CMD /bin/bash
