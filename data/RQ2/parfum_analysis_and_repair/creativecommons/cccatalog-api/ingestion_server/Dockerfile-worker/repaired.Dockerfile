FROM python:3.7

ENV PYTHONBUFFERED 1

# Install Python dependency management tools
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir --upgrade setuptools \
    && pip install --no-cache-dir --upgrade pipenv

# Copy all files into the container
COPY . /ingestion_server/
WORKDIR /ingestion_server
ENV PYTHONPATH=$PYTHONPATH:/ingestion_server/

RUN pipenv install --deploy --system --dev
EXPOSE 8002
CMD gunicorn indexer_worker:api -b 0.0.0.0:8002 --reload --access-logfile '-' --error-logfile '-' --chdir ./ingestion_server/
