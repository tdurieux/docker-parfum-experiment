FROM public.ecr.aws/lambda/python:$python_version

RUN yum -y install java-1.8.0-openjdk && rm -rf /var/cache/yum

COPY $requirements_file_path ./

RUN pip install --no-cache-dir -r ./requirements.txt

ENV SPARK_HOME="/var/lang/lib/python$python_version/site-packages/pyspark"
ENV PATH=$PATH:$SPARK_HOME/bin
ENV PATH=$PATH:$SPARK_HOME/sbin
ENV PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.9-src.zip:$PYTHONPATH
ENV PATH=$SPARK_HOME/python:$PATH
ENV SPARK_MASTER_HOST="localhost"
ENV SPARK_LOCAL_IP="127.0.0.1"

ENV JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk*/jre"
ENV PATH=$PATH:$JAVA_HOME/bin

COPY spark-class $SPARK_HOME/bin/
RUN chmod +x $SPARK_HOME/bin/spark-class

CMD ["lambda_function.lambda_handler"]