FROM debian:jessie
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends nagios3 monitoring-plugins-standard monitoring-plugins-basic supervisor vim net-tools curl git jq exim4 tzdata check-postgres python3 python3-pip libpq-dev nano -y && rm -rf /var/lib/apt/lists/*;
RUN ln -fs /usr/share/zoneinfo/Canada/Pacific /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive tzdata
RUN pip3 install --no-cache-dir "pika==0.12.0" && \
    pip3 install --no-cache-dir minio requests psycopg2
RUN curl -f --silent -L -o /tmp/oc.tgz https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
WORKDIR /tmp
RUN tar xzf oc.tgz && rm oc.tgz
RUN cp openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc /bin
