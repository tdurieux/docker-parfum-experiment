FROM python:3.7.2-slim
LABEL python_version=python3.7.2

# Set virtualenv environment variables. This is equivalent to running
# source /env/bin/activate
RUN seq 1 8 | xargs -I{} mkdir -p /usr/share/man/man{}
RUN for i in {1..8}; do mkdir -p "/usr/share/man/man$i"; done
RUN apt-get update
RUN apt-get install -y libpq-dev python3-dev build-essential postgresql postgresql-contrib
ADD eventhandlers/requirements.txt /app/
RUN pip3 install --upgrade pip
RUN pip3 install -r /app/requirements.txt

ADD eventhandlers/ /app/
ADD shared /app/shared

WORKDIR /app/
#CMD exec gunicorn --bind :$PORT --timeout 120 --worker-class eventlet --workers 3 --no-sendfile --config python:my_conf main:app
EXPOSE 8086
# When you just 'docker run publisher' with no command afterwards,
# default to this:
CMD ["python", "main.py"]