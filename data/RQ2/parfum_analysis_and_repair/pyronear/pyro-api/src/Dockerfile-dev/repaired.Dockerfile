FROM pyroapi:python3.8-alpine3.10

# copy requirements file
COPY requirements-dev.txt requirements-dev.txt

# install dependencies
RUN pip install --no-cache-dir -r requirements-dev.txt \
    && rm -rf /root/.cache/pip

# copy project
COPY .coveragerc /app/.coveragerc
COPY tests /app/tests