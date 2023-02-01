FROM python:3.9-slim-bullseye

# Set separate working directory for easier debugging.
WORKDIR /app

RUN --mount=type=cache,target=/root/.cache/pip pip install --no-cache-dir --upgrade pip setuptools wheel

# Install requirements seperately
# to take advantage of layer caching.
COPY requirements*.txt .
RUN --mount=type=cache,target=/root/.cache/pip pip install --no-cache-dir --upgrade -r requirements.txt -r

# Set up dbt-related dependencies.
RUN --mount=type=cache,target=/root/.cache/pip pip install --no-cache-dir dbt-postgres
# N.B. we extract the requirements from plugins/sqlfluff-templater-dbt/setup.cfg,
# filtering out sqlfluff itself, to prevent it from being installed as a package.
# (Below, we install it in editable mode.)
COPY plugins/sqlfluff-templater-dbt/setup.cfg /tmp
RUN python -c "import configparser; c = configparser.ConfigParser(); c.read('/tmp/setup.cfg'); print(c['options']['install_requires'])" | grep -v sqlfluff > /tmp/dbt-requirements.txt
RUN --mount=type=cache,target=/root/.cache/pip pip install --no-cache-dir --upgrade -r /tmp/dbt-requirements.txt

# Copy everything. (Note: If needed, we can use .dockerignore to limit what's copied.)
COPY . .

# Install sqlfluff and the dbt templater in editable mode.
RUN pip install --no-cache-dir --no-dependencies -e . -e
