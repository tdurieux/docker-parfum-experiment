FROM python:3.9-slim

# Set pip to have cleaner logs and no saved cache
ENV PIP_NO_CACHE_DIR=false

# Create the working directory
WORKDIR /bot

# Install project dependencies

# as we have a git dep, install git
RUN apt update && apt install --no-install-recommends git gcc -y && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -U pip wheel setuptools
RUN pip install --no-cache-dir poetry==1.1.13

# export requirements after copying req files
COPY pyproject.toml poetry.lock ./
RUN poetry export --without-hashes > requirements.txt
RUN pip uninstall poetry -y
RUN pip install --no-cache-dir -Ur requirements.txt

# Set SHA build argument
ARG git_sha="main"
ENV GIT_SHA=$git_sha

# Copy the source code in next to last to optimize rebuilding the image
COPY . .

# install the package using pep 517
RUN pip install --no-cache-dir . --no-deps

ENTRYPOINT ["python3", "-m", "monty"]
