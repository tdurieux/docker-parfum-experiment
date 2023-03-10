FROM balenalib/%%BALENA_ARCH%%-debian-python:3.9.5-buster-run

# setup application working directory
WORKDIR /app

# setup environment variables
ENV PYTHONUNBUFFERED 1

# prepare dependencies files
COPY requirements.txt /tmp/requirements.txt

# install python dependencies
RUN pip install --no-cache-dir -r /tmp/requirements.txt \
 # clean up
 && rm -rf /tmp/*

# install app
COPY app/ /app/

# setup entrypoint
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]