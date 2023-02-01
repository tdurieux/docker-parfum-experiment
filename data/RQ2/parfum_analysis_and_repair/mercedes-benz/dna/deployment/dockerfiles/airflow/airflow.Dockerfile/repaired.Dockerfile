FROM python:3.7-slim
#as builder

# ARG PROXY=""

# ENV http_proxy=${PROXY}
# ENV https_proxy=${PROXY}

RUN apt-get update -y && apt-get install --no-install-recommends -y \
    libczmq-dev \
    libssl-dev \
    inetutils-telnet \
    bind9utils \
    gcc \
    git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir Flask-OIDC==1.4.0
RUN pip install --no-cache-dir fab-oidc==0.0.9
RUN pip install --no-cache-dir Flask-Bcrypt==0.7.1

RUN pip install --no-cache-dir apache-airflow==1.10.15
RUN pip install --no-cache-dir 'apache-airflow[kubernetes]'
RUN pip install --no-cache-dir 'apache-airflow[postgres]'
#RUN pip install airflow-code-editor
#RUN pip install black
RUN pip install --no-cache-dir boto3
RUN pip install --no-cache-dir botocore

RUN cd /usr/local && mkdir airflow && chmod +x airflow && cd airflow

ARG AIRFLOW_USER_HOME=/usr/local/airflow
ENV AIRFLOW_HOME=${AIRFLOW_USER_HOME}

RUN useradd -ms /bin/bash 1000
RUN usermod -a -G sudo 1000

COPY airflow-env-init.sh /tmp/airflow-env-init.sh

RUN chmod 777 /tmp/airflow-env-init.sh

RUN chmod -R 777 /usr/local/airflow

COPY bootstrap.sh /bootstrap.sh
RUN chmod +x /bootstrap.sh
USER 1000
ENTRYPOINT ["/bootstrap.sh"]

RUN pip install --no-cache-dir SQLAlchemy==1.3.23
RUN pip install --no-cache-dir Flask-SQLAlchemy==2.4.4
RUN pip install --no-cache-dir Jinja2==3.0.3

# Use multistage build in order to unset proxy
# FROM builder

# ENV http_proxy=""
# ENV https_proxy=""
