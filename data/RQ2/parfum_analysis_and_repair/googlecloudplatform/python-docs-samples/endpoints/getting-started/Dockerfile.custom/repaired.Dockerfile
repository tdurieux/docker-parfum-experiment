# The Google App Engine python runtime is Debian Jessie with Python installed
# and various os-level packages to allow installation of popular Python
# libraries. The source is on github at:
#   https://github.com/GoogleCloudPlatform/python-docker
FROM gcr.io/google_appengine/python

RUN apt-get update && \
    apt-get install --no-install-recommends -y python2.7 python-pip && \
    apt-get clean && \
    rm /var/lib/apt/lists/*_*

ADD . /app
WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt
ENTRYPOINT ["gunicorn", "-b", ":8080", "main:app"]
