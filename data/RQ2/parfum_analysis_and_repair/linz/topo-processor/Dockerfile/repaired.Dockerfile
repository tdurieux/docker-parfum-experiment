FROM osgeo/gdal:ubuntu-small-3.5.0

# Install Poetry
RUN apt-get update && apt-get install --no-install-recommends python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir poetry

# Set environment variable to prevent GDAL running in Docker
ENV IS_DOCKER=true

WORKDIR /app
# Add Poetry config and scripts
COPY poetry.lock pyproject.toml VERSION /app/

RUN poetry config virtualenvs.create false \
  && poetry install --no-dev --no-interaction --no-ansi

COPY ./topo_processor /app/topo_processor
COPY ./upload /app/
