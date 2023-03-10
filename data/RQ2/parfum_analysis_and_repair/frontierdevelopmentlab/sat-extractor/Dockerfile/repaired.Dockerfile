# Use the official osgeo/gdal image.
FROM osgeo/gdal:ubuntu-small-latest

# Allow statements and log messages to immediately appear in the Knative logs
ENV PYTHONUNBUFFERED True

# Set provider dir path
ENV PROVIDER providers/gcp

ENV APP_HOME /app

RUN if [ -z "$MONITOR_TABLE" ]; then echo 'WARNING: Environment variable MONITOR_TABLE not specified. Task statuses wont be output.'; fi


WORKDIR $APP_HOME
# Copy local code to the container image.
COPY . ./satextractor
COPY $PROVIDER ./
# Install GDAL dependencies
RUN apt-get update && apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
# Install production dependencies.
RUN pip install --no-cache-dir ./satextractor
RUN pip install --no-cache-dir -r requirements.txt

# Run the web service on container startup. Here we use the gunicorn
# webserver, with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
# Timeout is set to 0 to disable the timeouts of the workers to allow Cloud Run to handle instance scaling.
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 main:app
