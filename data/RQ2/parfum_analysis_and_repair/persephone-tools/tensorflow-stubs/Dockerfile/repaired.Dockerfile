FROM python:3.6.6-slim-stretch

RUN apt-get -qq update && apt-get install --no-install-recommends -qq -y \
  apt-utils \
  locales \
  git \
  python-pip && rm -rf /var/lib/apt/lists/*;

# copy files and set workdir
ADD . /tensorflow-stubs
WORKDIR /tensorflow-stubs

RUN ["/bin/bash", "-c", "rm -r ./{.mypy_cache/,.pytest_cache/,tests/__pycache__/}"]
RUN pip install --no-cache-dir pipenv && pipenv install --dev --skip-lock
CMD pipenv run pytest