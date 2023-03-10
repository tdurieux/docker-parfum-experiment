FROM tiangolo/uwsgi-nginx:python3.6

# Install requirements (dependencies). Changing the lock file will trigger updates
RUN apt-get update & apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;

ADD Pipfile Pipfile.lock ./
RUN pip install --no-cache-dir pipenv
RUN pipenv install --system

# Add the application code
COPY burn ./burn/

# Add our default docker files (such as wsgi.py entrypoint)
ADD docker_files/* ./