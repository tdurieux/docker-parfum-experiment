# Creates environment to run unit tests with current nightly image.
FROM tensorflow/tensorflow:2.9.1-gpu
COPY . /kerasnlp
WORKDIR /kerasnlp
RUN apt-get -y update && apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r cloudbuild/requirements.txt