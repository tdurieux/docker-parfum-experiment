FROM ubuntu:20.04
RUN apt-get update                           && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y python3 && \
    apt-get install --no-install-recommends -y python3-pip && \
    DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y uwsgi && \
    apt-get install --no-install-recommends -y uwsgi-plugin-python3 && \
    echo done && rm -rf /var/lib/apt/lists/*;

# The DEBIAN_FRONTEND config needed for tzdata installation

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
RUN rm -f requirements.txt


COPY . /opt/
COPY uwsgi.ini /etc/uwsgi/apps-enabled/

WORKDIR /opt

CMD service uwsgi start; tail -F /var/log/uwsgi/app/uwsgi.log

