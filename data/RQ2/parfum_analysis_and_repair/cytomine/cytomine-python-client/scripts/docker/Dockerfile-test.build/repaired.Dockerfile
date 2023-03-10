FROM python:3.8.12 AS imageWithDependencies

# We first copy the requirements.txt file
# This way, we retrieve all maven dependencies at the beginning. All these steps will be cached by Docker unless requirements.txt has been updated.
# This means that we only retrieve all dependencies if we modify the dependencies definition.

COPY requirements.txt /app/requirements.txt

RUN cd /app && \
    pip install --no-cache-dir -r requirements.txt

FROM imageWithDependencies

RUN pip install --no-cache-dir -U pytest

COPY . /app

ARG VERSION_NUMBER

ENV VERSION_NUMBER_ENV=$VERSION_NUMBER
WORKDIR /app

CMD pytest cytomine/tests --host localhost-core --public_key 4c6339f4-289a-4add-82cf-120a6a808b6f --private_key 563de51e-d78c-4e07-9589-7873bd3341be --junit-xml=ci/test-reports/pytest_unit.xml
