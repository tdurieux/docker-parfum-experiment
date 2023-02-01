FROM	python:2
RUN pip install --no-cache-dir gcalcli
ENTRYPOINT	["gcalcli"]
