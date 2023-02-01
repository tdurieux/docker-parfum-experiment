FROM python:3.8-buster

# Install Docker dependencies
RUN apt-get update
RUN apt-get install -y sudo docker.io

# Create non-root user with sudo access
RUN useradd -r worker
RUN echo "worker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

COPY ./requirements.txt /
RUN pip install -r /requirements.txt
RUN rm /requirements.txt

WORKDIR /worker
COPY . /worker/worker

RUN flake8 --extend-ignore=E722 --max-complexity 12 .

CMD celery worker --app worker.worker --loglevel=info
