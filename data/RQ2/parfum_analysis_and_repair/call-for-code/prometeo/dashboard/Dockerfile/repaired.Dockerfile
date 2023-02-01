FROM registry.access.redhat.com/ubi8/python-36

WORKDIR /app

COPY requirements.txt /tmp/requirements.txt

## NOTE - rhel enforces user container permissions stronger ##
USER root
RUN yum install -y python3-pip wget && rm -rf /var/cache/yum

RUN pip install --no-cache-dir --upgrade pip \
  && pip install --no-cache-dir --upgrade pipenv \
  && pip install --no-cache-dir --upgrade -r /tmp/requirements.txt

USER 1001

COPY . /app
ENV FLASK_APP=server/__init__.py
CMD ["python", "manage.py", "start", "0.0.0.0:3000"]
