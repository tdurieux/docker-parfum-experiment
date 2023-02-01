FROM python:3.7-alpine
RUN apk update && apk add --no-cache git
COPY dist/*.whl .
RUN pip install --no-cache-dir -U $(ls *.whl)[full] && rm *.whl
ENTRYPOINT ["git-fame", "/repo"]
