RUN apt-get update && apt-get install --no-install-recommends -y \
    alien dpkg-dev debhelper build-essential \
    libaio1 libsndfile-dev && \
    wget https://download.oracle.com/otn_software/linux/instantclient/199000/oracle-instantclient19.9-basic-19.9.0.0.0-1.x86_64.rpm && \
    alien -i oracle-instantclient19.9-basic-19.9.0.0.0-1.x86_64.rpm && rm -rf /var/lib/apt/lists/*;

