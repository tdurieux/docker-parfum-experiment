FROM python:3.6

# do these on one line so changes trigger apt-get update
RUN apt-get update && \
    apt-get install --no-install-recommends -y python-pip netcat python-dev python3-dev postgresql && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir pip --upgrade
RUN pip install --no-cache-dir virtualenv
RUN pip install --no-cache-dir virtualenvwrapper
RUN pip install --no-cache-dir tox
ENV AM_I_IN_A_DOCKER_CONTAINER=True

RUN useradd -mU dbt_test_user
USER dbt_test_user

WORKDIR /usr/src/app
RUN cd /usr/src/app
