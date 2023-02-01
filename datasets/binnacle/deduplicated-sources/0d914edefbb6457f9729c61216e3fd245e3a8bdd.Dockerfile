FROM python:3.6

RUN  mkdir /tmp/output && \
     mkdir /var/log/oasis

RUN apt-get update && apt-get install -y --no-install-recommends \ 
            vim libspatialindex-dev python-dev && rm -rf /var/lib/apt/lists/* 

RUN pip install tox flake8 coverage

WORKDIR /home
CMD ./docker/entrypoint_unittest.sh
