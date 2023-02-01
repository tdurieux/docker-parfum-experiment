FROM python:3.9-slim

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1
# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1

# Install essential tools
RUN apt-get -y update && apt-get install --no-install-recommends -y \
    wget \
    gnupg \
    lsb-release && rm -rf /var/lib/apt/lists/*;

# Install and setup poetry
RUN pip install --no-cache-dir -U pip \
    && apt install --no-install-recommends -y curl \
    && curl -f -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python && rm -rf /var/lib/apt/lists/*;
ENV PATH="${PATH}:/root/.poetry/bin"

# Install mongotools, used for getting mongo backups
RUN wget https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu2004-x86_64-100.5.0.deb -O mongo-tools.deb \
    && apt install --no-install-recommends -y ./mongo-tools.deb && rm -rf /var/lib/apt/lists/*;

# Install redis-tools, used for redis backups.
RUN apt install --no-install-recommends -y redis-tools && rm -rf /var/lib/apt/lists/*;

# Install the Postgres 14 client, needed for pg_dumpall
# And MariaDB client for mysqldump
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y postgresql-client-14 mariadb-client && rm -rf /var/lib/apt/lists/*;

# Create and set the working directory, so we don't make a mess in the Docker filesystem.
WORKDIR /blackbox

# Copy the project files into working directory
COPY . .

# Run poetry
RUN poetry config virtualenvs.create false \
  && poetry install --no-interaction --no-ansi

# Start the application!
CMD poetry run blackbox
