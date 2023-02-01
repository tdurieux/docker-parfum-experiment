# docker build -t oracle2datacatalog .
FROM python:3.7

# Set the GOOGLE_APPLICATION_CREDENTIALS environment variable.
# At run time, /data must be binded to a volume containing a valid Service Account credentials file
# named oracle2dc-credentials.json.
ENV GOOGLE_APPLICATION_CREDENTIALS=/data/oracle2dc-credentials.json
ENV ORACLE_HOME=/opt/oracle/instantclient_19_5
ENV LD_LIBRARY_PATH=$ORACLE_HOME
ENV LD_RUN_PATH=$ORACLE_HOME

RUN curl -f https://download.oracle.com/otn_software/linux/instantclient/195000/instantclient-basic-linux.x64-19.5.0.0.0dbru.zip > instantclient-basic-linux.x64-19.5.0.0.0dbru.zip
RUN mkdir -p /opt/oracle && \
unzip "instantclient*.zip" -d /opt/oracle && \
ln -s $ORACLE_HOME

RUN apt-get update \
 && apt-get install --no-install-recommends libaio1 -y && rm -rf /var/lib/apt/lists/*;

# Copy the local client library dependency and install it (temporary).
WORKDIR /lib

RUN pip install --no-cache-dir flake8
RUN pip install --no-cache-dir yapf

WORKDIR /app

# Copy project files (see .dockerignore).
COPY . .

RUN yapf --diff --recursive src tests
RUN flake8 src tests

# Install oracle2datacatalog package from source files.
RUN pip install --no-cache-dir .

RUN python setup.py test

ENTRYPOINT ["google-datacatalog-oracle-connector"]
