ARG TAG=2.7-stretch
FROM python:$TAG

WORKDIR /app

# create the venv and install some dependencies when required
RUN if command -v virtualenv; then\
    virtualenv venv;\
  else\
    python3 -m venv venv;\
    venv/bin/pip install mypy lxml;\
    venv/bin/pip install types-all sqlalchemy-stubs; \
  fi

COPY requirements.txt requirements-py3.txt /app/

# install the requirements from the requirements file depending on the python version
RUN if command -v virtualenv; then\
    venv/bin/pip install -r requirements.txt;\
  else\
    venv/bin/pip install -r requirements-py3.txt;\
  fi

ARG OM_PYPI_INDEX_URL
COPY requirements-openmotics-py3.txt /app/
# install the openmotics requirements depending on the python version
RUN if [ -n "$OM_PYPI_INDEX_URL" ]; then\
    venv/bin/pip install --extra-index-url "$OM_PYPI_INDEX_URL" -r requirements-openmotics-py3.txt;\
  fi

ENV PATH="/app/venv/bin:${PATH}"
