FROM bitnami/minideb:jessie

RUN install_packages python2.7 curl ca-certificates git
RUN curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py
RUN python2.7 ./get-pip.py

RUN pip install bottle==0.12.13 cherrypy==8.9.1 wsgi-request-logger prometheus_client

ADD kubeless.py /

USER 1000

CMD ["python2.7", "/kubeless.py"]
