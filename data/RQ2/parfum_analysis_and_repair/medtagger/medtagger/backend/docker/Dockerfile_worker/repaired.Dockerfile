FROM python:3.7.1

WORKDIR /medtagger_backend/

COPY Makefile ./Makefile
COPY alembic ./alembic
COPY medtagger ./medtagger
COPY scripts ./scripts
COPY tests ./tests

COPY .flake8 ./.flake8
COPY .pylintrc ./.pylintrc
COPY .test.pylintrc ./.test.pylintrc
COPY alembic.ini ./alembic.ini
COPY logging.conf ./logging.conf
COPY mypy.ini ./mypy.ini
COPY requirements.dev.txt ./requirements.dev.txt
COPY requirements.txt ./requirements.txt

ENV PYTHONPATH /medtagger_backend

ARG CASS_DRIVER_NO_CYTHON
ARG CASS_DRIVER_NO_EXTENSIONS
RUN pip install --no-cache-dir -r requirements.txt

ENV C_FORCE_ROOT true
CMD ["celery", "-A", "medtagger.workers", "worker", "--loglevel=info"]
