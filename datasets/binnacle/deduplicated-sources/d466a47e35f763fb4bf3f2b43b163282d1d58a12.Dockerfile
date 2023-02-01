FROM cluster-hadoop

RUN wget https://archive.apache.org/dist/spark/spark-1.6.0/spark-1.6.0-bin-hadoop2.6.tgz \
    && tar -zxvf /spark-1.6.0-bin-hadoop2.6.tgz -C /usr/local/ \
    && mv /usr/local/spark-1.6.0-bin-hadoop2.6 /usr/local/spark \
    && rm /spark-1.6.0-bin-hadoop2.6.tgz

COPY ./conf/slaves /usr/local/spark/conf/
COPY ./conf/spark-env.sh /usr/local/spark/conf/

# 配置 pyspark 的 python3 环境，并设置 ipython 接口。
ENV PYSPARK_PYTHON=python3
ENV PYSPARK_DRIVER_PYTHON=ipython
ENV SPARK_HOME=/usr/local/spark

WORKDIR /spark

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
