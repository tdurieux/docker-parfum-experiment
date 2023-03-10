FROM python:3.7-stretch

ENV PYTHONBUFFERED 1

RUN apt-get update \
    && apt-get install -y --no-install-recommends libexempi3 \
    && mkdir /cccatalog-api \
    && mkdir -p /var/log/cccatalog-api/cccatalog-api.log && rm -rf /var/lib/apt/lists/*;

ADD cccatalog/api/utils/fonts/SourceSansPro-Bold.ttf /usr/share/fonts/truetype/SourceSansPro-Bold.ttf

WORKDIR /cccatalog-api

# Install Python dependency management tools
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir --upgrade setuptools \
    && pip install --no-cache-dir --upgrade pipenv

# Copy the Pipenv files into the container
COPY Pipfile /cccatalog-api/
COPY Pipfile.lock /cccatalog-api/

# Install the dependencies system-wide
# TODO: Use build args to avoid installing dev dependencies in production
RUN pipenv install --deploy --system --dev

ENTRYPOINT ["./run.sh"]
