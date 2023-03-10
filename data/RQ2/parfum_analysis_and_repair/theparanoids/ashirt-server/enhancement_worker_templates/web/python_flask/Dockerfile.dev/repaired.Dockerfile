FROM python:3.10-alpine

# With help from https://pipenv.pypa.io/en/latest/basics/#pipenv-and-docker-containers

WORKDIR /app
ENV PIPENV_VENV_IN_PROJECT=1

RUN pip install --no-cache-dir --user pipenv

###################################
# Install other dependencies here #
###################################

COPY Pipfile.lock Pipfile ./
COPY src ./src/

RUN /root/.local/bin/pipenv sync

# Opting to use volume instead of copying to enable hot-reload
# COPY src ./src

ENV FLASK_APP src/wsgi.py
ENV FLASK_DEBUG 1
ENV FLAKS_ENV=developement

EXPOSE 80
CMD ["/root/.local/bin/pipenv", "run", \
     "flask", "run", \
     "--host=0.0.0.0", "--port=8080"]
