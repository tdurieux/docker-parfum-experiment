# The correct AWS SAM build image based on the runtime of the function will be
# passed as build arg. The default allows to do `docker build .` when testing.
ARG IMAGE=amazon/aws-sam-cli-build-image-python3.7
FROM $IMAGE

# Ensure rsync is installed
RUN yum -q list installed rsync & >/dev/null || yum install -y rsync && rm -rf /var/cache/yum

# Upgrade pip (required by cryptography v3.4 and above, which is a dependency of poetry)
RUN pip install --no-cache-dir --upgrade pip

# Install pipenv and poetry so we can create a requirements.txt if we detect pipfile or poetry.lock respectively
RUN pip install --no-cache-dir pipenv poetry

# Install the dependencies in a cacheable layer
WORKDIR /var/dependencies
COPY Pipfile* pyproject* poetry* requirements.tx[t] ./

# Run these command separately
# Note: "pipenv lock -r > requirements.txt" command can fail if the pipenv is using a Python version (ie. Python3.9)
#       that's not the same as the Lambda Python version (ie. Python3.8)
RUN if [ -f 'Pipfile' ]; then pipenv lock -r > requirements.txt; else echo "Pipfile not found"; fi
RUN if [ -f 'poetry.lock' ]; then poetry export --with-credentials --format requirements.txt --output requirements.txt; else echo "poetry.lock not found"; fi
RUN if [ -f 'requirements.txt' ]; then \
 pip install --no-cache-dir -r requirements.txt -t .; else echo "requirements.txt not found"; fi

CMD [ "python" ]
