FROM python:3.8.1-alpine

RUN pip install --no-cache-dir {{ cookiecutter.project_slug }}

CMD {{ cookiecutter.project_slug }}
