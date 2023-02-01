ARG ETK_VERSION

# dig-etl-engine
FROM uscisii2/etk:${ETK_VERSION}

# all packages and environments are in /app
WORKDIR /app
RUN mkdir /app/dig-etl-engine

## install required command utils
RUN apt-get update && apt-get install -y default-jre

# download kafka (for command tools)
RUN wget "http://apache.claz.org/kafka/0.11.0.3/kafka_2.11-0.11.0.3.tgz" && \
    tar -xvzf "kafka_2.11-0.11.0.3.tgz" && rm "kafka_2.11-0.11.0.3.tgz" && \
    mv "kafka_2.11-0.11.0.3" kafka

# install dependencies
ADD requirements.txt /app/dig-etl-engine
RUN pip install -r /app/dig-etl-engine/requirements.txt

# persistent data
VOLUME /shared_data

EXPOSE 9999

# add current dir to image at last (or it will break the cache of docker)
WORKDIR /app/dig-etl-engine
ADD . /app/dig-etl-engine

CMD /bin/bash -c "python manager.py"
