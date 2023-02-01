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
    && apt install --no-install-recommends -y curl netcat \
    && curl -f -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python && rm -rf /var/lib/apt/lists/*;
ENV PATH="${PATH}:/root/.poetry/bin"

WORKDIR /code
COPY . /code
# Run poetry
RUN poetry config virtualenvs.create false \
  && poetry install --no-interaction --no-ansi


ENTRYPOINT ["/code/entrypoint.sh"]