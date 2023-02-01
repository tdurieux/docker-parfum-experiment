# arxiv/classic-api
#
# Defines the runtime for the arXiv classic API, which provides a metadata
# query API backed by Elasticsearch.

FROM arxiv/base:0.16.6

WORKDIR /opt/arxiv


ENV LC_ALL en_US.utf8
ENV LANG en_US.utf8
ENV LOGLEVEL 40
ENV PIPENV_VENV_IN_PROJECT 1
ENV FLASK_DEBUG 1
ENV FLASK_APP /opt/arxiv/classic-api.py
ENV PATH "/opt/arxiv:${PATH}"
ENV ELASTICSEARCH_SERVICE_HOST 127.0.0.1
ENV ELASTICSEARCH_SERVICE_PORT 9200
ENV ELASTICSEARCH_SERVICE_PORT_9200_PROTO http
ENV ELASTICSEARCH_INDEX arxiv
ENV ELASTICSEARCH_USER elastic
ENV ELASTICSEARCH_PASSWORD changeme
ENV METADATA_ENDPOINT https://arxiv.org/docmeta_bulk/


# Add Python application and configuration.
ADD Pipfile /opt/arxiv/
ADD Pipfile.lock /opt/arxiv/
RUN pip install --no-cache-dir -U pip pipenv
RUN pipenv sync --dev
ADD classic-api.py /opt/arxiv/
ADD schema /opt/arxiv/schema
ADD mappings /opt/arxiv/mappings
ADD search /opt/arxiv/search
ADD wsgi-classic-api.py config/uwsgi-classic-api.ini /opt/arxiv/


EXPOSE 8000

ENTRYPOINT ["pipenv", "run"]
CMD ["uwsgi", "--ini", "/opt/arxiv/uwsgi-classic-api.ini"]
