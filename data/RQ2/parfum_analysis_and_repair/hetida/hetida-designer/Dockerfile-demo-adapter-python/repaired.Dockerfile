##### Build stage
FROM python:3.9.9-buster as base

ENV TIMEOUT=60

COPY ./demo-adapter-python/requirements.txt /requirements.txt
COPY ./demo-adapter-python/requirements-dev.txt /requirements-dev.txt

RUN python3 -m pip install --upgrade pip==21.3.1 pip-tools==6.4.0 wheel==0.37.0
RUN pip-sync /requirements.txt

##### Intermediate stage with actual application content
FROM base AS application_base
COPY ./demo-adapter-python /app
COPY ./VERSION /app/VERSION
RUN chmod +x /app/start.sh

##### Production stage
# making prod stage available early allows to build it without building test stage
# since test stage is only necessary on build system
FROM application_base AS prod
RUN useradd -m hdda_app
USER hdda_app
WORKDIR /app
# trying to make global multiprocessing.Manager objects possible across worker processes:
ENV GUNICORN_CMD_ARGS "--preload"
ENV PORT 8092
EXPOSE 8092
CMD ["/app/start.sh"]

##### Test stage
FROM application_base AS test
WORKDIR /app
RUN pip-sync /requirements.txt /requirements-dev.txt
RUN python3 -m pytest --cov=demo_adapter_python --cov-report xml --junitxml test_results.xml tests
RUN bash /app/scripts/gen_pylint_report.sh

# prod should still be the default build, this is why we close with FROM prod
# Note that in order to really skip the test stage you either need to explicitly specify the prod
# stage via 
#     docker build --target prod -f Dockerfile-demo-adapter-python . -t hetdes_demo_adapter_python