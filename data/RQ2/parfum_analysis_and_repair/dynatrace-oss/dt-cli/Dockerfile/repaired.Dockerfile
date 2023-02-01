FROM python:3.9

# Install package build system
RUN pip install --no-cache-dir poetry

# Project directory must be mounted in /app
WORKDIR /app

COPY . .
RUN poetry install

CMD [ "tail", "-f", "/dev/null" ]
