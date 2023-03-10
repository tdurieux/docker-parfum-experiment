FROM debian
MAINTAINER USTC-Software, developers@biohub.tech
EXPOSE 5000

WORKDIR /root
RUN apt update && apt install --no-install-recommends -y \
        git \
        python3 \
        python3-pip \
        python3-biopython \
        python3-flask \
        python3-sqlalchemy \
        python3-scipy \
        libmysqlclient-dev \
        mysql-client \
        wget \
    && pip3 install --no-cache-dir \
        flask_login \
        mysqlclient \
        pymysql && rm -rf /var/lib/apt/lists/*;
ADD . .
RUN mv config.docker.py config.py

ENTRYPOINT ./run.py
