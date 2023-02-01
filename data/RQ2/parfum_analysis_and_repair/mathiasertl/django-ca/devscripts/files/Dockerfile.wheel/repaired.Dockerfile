# Dockerfile to test wheels in an isolated environment

ARG IMAGE=python:3.10

#########################
# Build sdist and wheel #
#########################
FROM $IMAGE as build
WORKDIR /work/

RUN pip install --no-cache-dir -U pip

ADD requirements/requirements-dist.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Add full source code so that we can build a wheel.
ADD LICENSE MANIFEST.in README.md setup.cfg setup.py pyproject.toml ./
ADD docs/source/intro.rst docs/source/
ADD ca/django_ca ca/django_ca

# Build and test wheel
RUN python -m build
RUN twine check --strict dist/*

FROM $IMAGE as test-base
RUN pip install --no-cache-dir -U pip
WORKDIR /work/
COPY setup.cfg devscripts/test-imports.py ./

# Test sdist
FROM test-base as sdist-test
COPY --from=build /work/dist/django-ca*.tar.gz dist/
RUN pip install --no-cache-dir dist/django-ca*.tar.gz
RUN ./test-imports.py

FROM test-base as wheel-base
COPY --from=build /work/dist/django_ca*.whl dist/

# Test wheel
FROM wheel-base as wheel-test
RUN pip install --no-cache-dir dist/django_ca*.whl
RUN ./test-imports.py

# Twest wheel in combination with extras
FROM wheel-base as wheel-test-acme
RUN pip install --no-cache-dir $(ls dist/django_ca*.whl)[acme]
RUN ./test-imports.py --extra=acme

FROM wheel-base as wheel-test-redis
RUN pip install --no-cache-dir $(ls dist/django_ca*.whl)[redis]
RUN ./test-imports.py --extra=redis

FROM wheel-base as wheel-test-celery
RUN pip install --no-cache-dir $(ls dist/django_ca*.whl)[celery]
RUN ./test-imports.py --extra=celery

FROM wheel-base as wheel-test-mysql
RUN pip install --no-cache-dir $(ls dist/django_ca*.whl)[mysql]
RUN ./test-imports.py --extra=mysql

FROM wheel-base as wheel-test-postgres
RUN pip install --no-cache-dir $(ls dist/django_ca*.whl)[postgres]
RUN ./test-imports.py --extra=postgres
