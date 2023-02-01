FROM python:3.9

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Poetry
COPY pyproject.toml /
RUN \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir poetry
RUN poetry config virtualenvs.create false && \
    poetry install --no-dev
# End Poetry

# Set work directory
WORKDIR /app

# Copy project
COPY src .

# Prepare entry point
COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
