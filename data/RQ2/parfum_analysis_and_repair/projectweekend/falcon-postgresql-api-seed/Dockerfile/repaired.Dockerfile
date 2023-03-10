FROM python:3.5

RUN apt-get update && apt-get -y --no-install-recommends install default-jre unzip socat && rm -rf /var/lib/apt/lists/*;
RUN wget https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/3.2.1/flyway-commandline-3.2.1.zip && unzip flyway-commandline-3.2.1.zip -d /opt && chmod a+x /opt/flyway-3.2.1/flyway
ENV PATH $PATH:/opt/flyway-3.2.1

ADD ./sql /opt/flyway-3.2.1/sql/
ADD . /src/
WORKDIR /src
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000
