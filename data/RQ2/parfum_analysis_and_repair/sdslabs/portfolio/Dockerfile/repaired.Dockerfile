FROM python:3.7-stretch

ENV PYTHONBUFFERED 1

RUN apt-get update \
    && apt-get install -y --no-install-recommends libexempi3 \
    && mkdir -p /var/log/portfolio.log && rm -rf /var/lib/apt/lists/*;

WORKDIR /portfolio

# Install Python dependency management tools
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir --upgrade setuptools

# Copy the requirements.txt into the container
COPY settings/requirements-common.txt /portfolio/
COPY settings/dev/requirements-dev.txt /portfolio/

# Install the dependencies system-wide
# TODO: Use build args to avoid installing dev dependencies in production
RUN pip install --no-cache-dir -r requirements-common.txt
RUN pip install --no-cache-dir -r requirements-dev.txt
