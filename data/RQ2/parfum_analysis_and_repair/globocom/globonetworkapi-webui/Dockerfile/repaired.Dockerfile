FROM python:2.7

SHELL ["/bin/bash", "-c"]

RUN mkdir -p /netapi_webui
WORKDIR /netapi_webui

ADD . /netapi_webui/

CMD cd /netapi_webui

EXPOSE 8080

RUN apt-get update && \
    apt-get install --no-install-recommends -y libldap2-dev \
                       libsasl2-dev \
                       libssl-dev \
                       python-ldap \
                       net-tools \
                       dnsutils && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir virtualenv && virtualenv venv && . ./venv/bin/activate
RUN pip install --no-cache-dir -r requirements.txt
