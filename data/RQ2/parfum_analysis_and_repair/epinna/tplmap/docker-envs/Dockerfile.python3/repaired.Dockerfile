FROM python:2.7.15

RUN apt-get update && apt-get install --no-install-recommends dnsutils python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir mako jinja2 flask tornado
RUN pip install --no-cache-dir PyYAML requests

COPY  . /apps/
WORKDIR /apps/tests/

RUN sed -i 's/127\.0\.0\.1/0.0.0.0/' env_py_tests/webserver.py

EXPOSE 15001

CMD python3 env_py_tests/webserver.py
