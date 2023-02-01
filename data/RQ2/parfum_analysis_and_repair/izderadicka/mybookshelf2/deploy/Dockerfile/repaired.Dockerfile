FROM ubuntu:18.04

MAINTAINER ivan

ARG MBS2_ENVIRONMENT
ENV LANG C.UTF-8

# additional 12.04 depedencies
#   add-apt-repository -y  ppa:fkrull/deadsnakes &&\
#    sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list' &&\
#    wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add - &&\
#   ...
#ln -s /usr/bin/python3.5 /usr/bin/python3 &&\


RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common wget libffi-dev git build-essential && \
		apt-get install --no-install-recommends -y python3.6 libpq-dev python3.6-dev python3-pip && rm -rf /var/lib/apt/lists/*;


# RUN locale-gen en_US.UTF-8
# ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN mkdir /code &&\
    mkdir /data &&\
    chmod a+rwx /data

WORKDIR /code
ADD requirements.txt /code/
RUN pip3 install --no-cache-dir -r requirements.txt
ADD requirements-dev.txt /code
RUN if [ "X${MBS2_ENVIRONMENT}" = "Xdevelopment" ]; then \
    pip3 install --no-cache-dir -r /code/requirements-dev.txt; \
    fi




