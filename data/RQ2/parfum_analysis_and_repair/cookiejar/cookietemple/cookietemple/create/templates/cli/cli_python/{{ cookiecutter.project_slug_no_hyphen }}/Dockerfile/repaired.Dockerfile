FROM python:3.8.1-alpine

# A few Utilities to able to install C based libraries such as numpy
RUN apk update
RUN apk add --no-cache make automake gcc g++ git

RUN pip install --no-cache-dir {{ cookiecutter.project_slug }}

CMD {{ cookiecutter.project_slug }}
