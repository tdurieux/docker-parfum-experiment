ARG QGIS_TEST_VERSION
FROM  qgis/qgis:${QGIS_TEST_VERSION}
LABEL maintainer="matthias@opengis.ch"

ENV PYTHONPATH="/usr/share/qgis/python"

# Before updating apt, add MSSQL (client side) repo
RUN curl -f https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl -f https://packages.microsoft.com/config/ubuntu/18.04/prod.list | tee /etc/apt/sources.list.d/msprod.list

RUN apt-get update

# SO deps
RUN apt-get -y --no-install-recommends install \
    iputils-ping \
    dnsutils \
    nmap \
    wget \
    unzip \
    vim && rm -rf /var/lib/apt/lists/*;

# Install OpenJDK-8
RUN apt-get install --no-install-recommends -y openjdk-8-jdk && \
    apt-get install --no-install-recommends -y ant && \
    apt-get clean; rm -rf /var/lib/apt/lists/*;

# Fix certificate issues
RUN apt-get install -y --no-install-recommends ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f; rm -rf /var/lib/apt/lists/*;

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

RUN ACCEPT_EULA=Y apt-get --no-install-recommends install -y msodbcsql17 mssql-tools unixodbc unixodbc-dev && rm -rf /var/lib/apt/lists/*;

# Python deps
RUN apt-get -y --no-install-recommends install \
    python3-pip \
    python3-pyodbc && rm -rf /var/lib/apt/lists/*;

# Avoid sqlcmd termination due to locale -- see https://github.com/Microsoft/mssql-docker/issues/163
RUN echo "nb_NO.UTF-8 UTF-8" > /etc/locale.gen
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen
ENV PATH="/usr/local/bin:${PATH}"

# Python pip installs
# temporally pip==9.0.3 version
RUN pip3 install --no-cache-dir --upgrade pip==9.0.3 && \
    pip3 install --no-cache-dir --upgrade psycopg2


ENV LANG=C.UTF-8

WORKDIR /
