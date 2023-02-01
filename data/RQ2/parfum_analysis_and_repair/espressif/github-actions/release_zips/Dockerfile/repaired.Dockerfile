FROM python:3.9-slim-buster

RUN apt-get update && apt-get install --no-install-recommends -y p7zip-full git && pip install --no-cache-dir PyGithub && rm -rf /var/lib/apt/lists/*;

ADD release_zips.py /release_zips.py

ENTRYPOINT ["python", "/release_zips.py"]
