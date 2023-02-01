FROM httpd

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        python3 python3-dev python3-setuptools python3-pip \
        libapr1-dev libaprutil1-dev gcc \
    && pip install --no-cache-dir mod_wsgi && rm -rf /var/lib/apt/lists/*;

ADD examples/wsgi/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

ADD . /tmp/latest
RUN pip install --no-cache-dir -e /tmp/latest --upgrade

ADD examples/wsgi/httpd.conf /usr/local/apache2/conf/httpd.conf
ADD examples/wsgi/app.py examples/wsgi/wsgi.py /var/flask/
