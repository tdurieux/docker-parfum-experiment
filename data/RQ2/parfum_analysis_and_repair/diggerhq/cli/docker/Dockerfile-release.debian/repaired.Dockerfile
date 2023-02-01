FROM python:3.7-buster
ENV PYTHONUNBUFFERED 1

# Adds our application code to the image
copy . /code/
WORKDIR /code/

RUN pwd

RUN pip install --no-cache-dir -r src/requirements.txt && pip install --no-cache-dir pyinstaller===3.5

ENTRYPOINT "docker/scripts/release.sh"
