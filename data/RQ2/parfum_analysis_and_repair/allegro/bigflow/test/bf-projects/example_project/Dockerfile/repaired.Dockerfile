FROM python:3.7
COPY ./dist /dist
RUN for i in /dist/*.whl; do pip install --no-cache-dir $i; done