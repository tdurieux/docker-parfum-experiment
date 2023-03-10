# arxiv/submission-api

FROM arxiv/base

WORKDIR /opt/arxiv

ENV LC_ALL en_US.utf8
ENV LANG en_US.utf8

# We're using MariaDB for testing/development, but production is MySQL (for
# now).
RUN yum -y install mariadb-devel && rm -rf /var/cache/yum

# Add Python consumer and configuration.
ADD metadata/Pipfile /opt/arxiv/Pipfile
RUN pip install --no-cache-dir pipenv
RUN pipenv install

ADD core/ /opt/arxiv/core/
RUN pipenv install /opt/arxiv/core/

ADD metadata/ /opt/arxiv/
ADD metadata/bin/entrypoint.sh /opt/arxiv/entrypoint.sh

ENV JWT_SECRET "foo"
EXPOSE 8000

#CMD /bin/bash

CMD ./entrypoint.sh --http-socket :8000 -w wsgi -M \
        -t 3000 --manage-script-name \
        --buffer-size 65535 \
        --processes 8 --threads 1 --async 100 --ugreen \
        --mount /submission=wsgi.py
