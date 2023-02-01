FROM debian:stable

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
        gfortran \
        git-core \
        libffi-dev \
        liblapack-dev \
        libopenblas-dev \
        libssl-dev \
        nginx \
        python3 \
        python3-dev \
        python3-mysqldb \
        python3-pip \
        python3-rpy2 \
        python3-setuptools \
        r-base \
        r-base-dev \
        uwsgi-core \
        vim && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir -Iv uwsgi Flask

ADD requirements.txt /requirements.txt
RUN pip3 install --no-cache-dir -Ivr /requirements.txt

EXPOSE 80
EXPOSE 8080

ADD . /app
RUN chmod -R 777 /app

CMD /app/boot.sh
