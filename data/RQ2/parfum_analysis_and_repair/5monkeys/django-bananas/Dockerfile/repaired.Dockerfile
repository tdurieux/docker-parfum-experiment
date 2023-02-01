ARG PYTHON=3
FROM python:${PYTHON}

# Install system dependencies
ARG REQUIREMENTS="requirements.txt"
ARG DJANGO=">=2.0.9,<2.3"
RUN apt-get update && apt-get install --no-install-recommends -y \
        gettext && \
    pip install --no-cache-dir --pre "Django${DJANGO}" && rm -rf /var/lib/apt/lists/*;

# Install requirements
COPY example/requirements* /tmp/
RUN pip install --no-cache-dir --pre -r /tmp/${REQUIREMENTS}

# Install bananas source
WORKDIR /usr/src
COPY . django-bananas
RUN pip install --no-cache-dir -e django-bananas && \
    rm -rf /usr/src/django-bananas/example && \
    mkdir /app

# Install example app
WORKDIR /app
COPY example ./

ENTRYPOINT ["python", "manage.py"]
