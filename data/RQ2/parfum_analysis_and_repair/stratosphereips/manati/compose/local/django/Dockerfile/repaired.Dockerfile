FROM python:2.7
ENV PYTHONUNBUFFERED 1
RUN groupadd -r manati \
&& useradd -r -g manati manati_user

RUN apt-get update && apt-get install --no-install-recommends -y gcc && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python python-pip python-dev libpq-dev python-setuptools \
                        build-essential \
                        software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libssl-dev libffi-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir /code
WORKDIR /code/
ADD ./requirements/base.txt /code/
ADD ./requirements/local.txt /code/
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir  setuptools
RUN pip install --no-cache-dir  -r local.txt
ADD . /code/
