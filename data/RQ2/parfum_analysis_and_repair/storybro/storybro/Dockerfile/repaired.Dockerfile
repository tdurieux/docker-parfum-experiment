from python:3.6.8

run apt-get update && apt-get install --no-install-recommends -y git aria2 unzip && rm -rf /var/lib/apt/lists/*;

workdir /storybro

env POETRY_VIRTUALENVS_CREATE=false

run pip install --no-cache-dir poetry tensorflow==1.15

run touch README.md
copy pyproject.toml pyproject.toml

run sed -i '/tensorflow/d' pyproject.toml

run poetry install --no-root

copy storybro/ storybro/

run pip install --no-cache-dir .

volume /models

entrypoint ["storybro"]
