FROM python:3.8-slim

COPY ./python_modules/ /tmp/python_modules/

WORKDIR /tmp

RUN pip install --no-cache-dir \
    -e python_modules/dagster \
    -e python_modules/dagster \
    -e python_modules/dagit \
    -e python_modules/librari \
    -e python_modules/librari


# Ensure all dagster installs were local
RUN ! (pip list --exclude-editable | grep -e dagster -e dagit)


ENV DAGSTER_HOME=/opt/dagster/dagster_home/
RUN mkdir -p $DAGSTER_HOME

COPY dagster.yaml workspace.yaml $DAGSTER_HOME

WORKDIR $DAGSTER_HOME
