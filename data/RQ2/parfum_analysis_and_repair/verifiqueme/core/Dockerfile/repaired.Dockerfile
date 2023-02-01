FROM python:3.6.5

# Create web directory
WORKDIR /var/app/www

# Install web dependencies
COPY Pipfile* ./

RUN apt-get update && \
    apt-get install --no-install-recommends build-essential software-properties-common libicu-dev python-pyicu python3-tk -y; rm -rf /var/lib/apt/lists/*;

# Install pipenv
RUN pip install --no-cache-dir pexpect uvicorn pipenv;

RUN pipenv install --system;

# Bundle web source
COPY . .
