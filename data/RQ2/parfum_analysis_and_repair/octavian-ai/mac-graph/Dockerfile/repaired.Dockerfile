# FROM gcr.io/tensorflow/tensorflow:1.7.0-rc0-py3
FROM gcr.io/google-appengine/python
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir pipenv

WORKDIR /source

# Only do costly pipenv install when needed
COPY Pipfile .
RUN pipenv install --verbose --skip-lock

COPY . .

CMD "./run-k8.sh"