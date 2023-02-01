FROM python:3.6

RUN pip install --no-cache-dir requests

# For development, Jupyter remote kernel, Hydrogen
# Using inside the container:
# jupyter notebook --ip=0.0.0.0 --allow-root
RUN pip install --no-cache-dir jupyter
EXPOSE 8888

RUN pip install --no-cache-dir faker==0.8.4 pytest

COPY ./app /app

ENV PYTHONPATH=/app

WORKDIR /app/app/rest_tests