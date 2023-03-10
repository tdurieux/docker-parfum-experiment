FROM python:3.8.12 AS imageWithDependencies

# We first copy the requirements.txt file
# This way, we retrieve all maven dependencies at the beginning. All these steps will be cached by Docker unless requirements.txt has been updated.
# This means that we only retrieve all dependencies if we modify the dependencies definition.

COPY requirements.txt /app/requirements.txt

RUN cd /app && \
    pip install --no-cache-dir -r requirements.txt
