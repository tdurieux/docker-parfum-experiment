from python:2.7
maintainer Sam Alba <sam@docker.com>

add requirements.txt /code/
workdir /code

run pip install --no-cache-dir -r requirements.txt

add . /code

env PYTHONUNBUFFERED true
cmd ["bin/bender"]
