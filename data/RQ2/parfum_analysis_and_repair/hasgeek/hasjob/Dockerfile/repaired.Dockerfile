FROM ubuntu:14.04

# Configure apt
RUN echo 'deb http://us.archive.ubuntu.com/ubuntu/ precise universe' >> /etc/apt/sources.list
RUN apt-get -y update && apt-get install --no-install-recommends -y build-essential git curl python python-dev python-setuptools software-properties-common python-software-properties libpq-dev libffi-dev libxml2-dev libxslt1-dev pandoc nodejs libjpeg-dev && rm -rf /var/lib/apt/lists/*;
RUN easy_install-2.7 pip

# add our requirements
ADD requirements.txt /code/hasjob/requirements.txt

# run pip install
RUN pip2.7 install -r /code/hasjob/requirements.txt

# copy over our code
ADD . /code/hasjob

WORKDIR /code/hasjob/

EXPOSE 5001
EXPOSE 5432
