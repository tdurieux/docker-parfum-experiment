FROM mcr.microsoft.com/vscode/devcontainers/python:0-3.7

RUN pip install pipenv
RUN cd scripts && ls
RUN pipenv run python scripts/initialize_database.py seed
