FROM python:3.8-slim

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONFAULTHANDLER 1

# Let service stop gracefully
STOPSIGNAL SIGQUIT

# Copy project files into working directory
WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends gcc -y && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir pipenv
COPY Pipfile Pipfile.lock ./
RUN pipenv install --deploy --system

ADD . /app

# Run the API.
CMD python launch.py runserver --initdb --verbose
