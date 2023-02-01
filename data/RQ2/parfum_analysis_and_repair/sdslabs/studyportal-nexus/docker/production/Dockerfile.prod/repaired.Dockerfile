FROM python:3.7-stretch as builder

ENV PYTHONBUFFERED 1

RUN apt-get update \
    && apt-get install -y --no-install-recommends libexempi3 \
    && mkdir -p /var/log/studyportal.log && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/app

# Install Python dependency management tools
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir --upgrade setuptools \
    && pip install --no-cache-dir --upgrade pipenv

# Copy all the files into the container
COPY . .

# Install the dependencies system-wide
# TODO: Use build args to avoid installing dev dependencies in production
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8005

# Specify custom entrypoint script
ENTRYPOINT ["./docker/production/run.sh"]
