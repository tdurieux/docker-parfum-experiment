FROM gcr.io/google-appengine/debian10:latest

RUN apt-get update && apt-get -y --no-install-recommends install python2.7 python-pip && pip install --no-cache-dir google-cloud-containeranalysis && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["python2.7"]
