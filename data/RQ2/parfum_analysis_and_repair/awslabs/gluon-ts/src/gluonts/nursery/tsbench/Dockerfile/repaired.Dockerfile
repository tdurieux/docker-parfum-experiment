FROM python:3.8.12-buster

# Install R
RUN apt-get update \
    && apt-get install --no-install-recommends -y r-base \
    && R -e 'install.packages(c("forecast", "nnfor"), repos="https://cloud.r-project.org")' && rm -rf /var/lib/apt/lists/*;

# Install project dependencies
RUN pip install --no-cache-dir poetry==1.1.6 \
    && poetry config virtualenvs.create false
COPY poetry.lock pyproject.toml /dependencies/
RUN cd /dependencies \
    && poetry install --no-dev --no-root --no-interaction --no-ansi
