FROM python:3.7
RUN pip install --no-cache-dir pipenv

WORKDIR /worker
COPY . /worker/
RUN apt-get update && apt-get -y --no-install-recommends install libmagickwand-dev && rm -rf /var/lib/apt/lists/*;
RUN pipenv install
ENV PYTHONUNBUFFERED 1
CMD PYTHONPATH=. pipenv run python worker/scheduler.py
