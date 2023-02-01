FROM python:3.4
ADD ./swarmsense /swarmsense
WORKDIR /swarmsense
RUN set -ex && apt-get update && apt-get install --no-install-recommends -y libpq-dev python-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r requirements.txt --no-build-isolation
RUN pip install --no-cache-dir swarmsense.tar.gz
CMD gunicorn -b 0.0.0.0:8000 -w 4 snms.__main__:app
