FROM ubuntu:latest
RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pipenv
COPY entrypoint.sh /entrypoint.sh
COPY *.py gh2jira Pipfile /
RUN cd / && PIPENV_VENV_IN_PROJECT=1 pipenv install
ENTRYPOINT ["/entrypoint.sh"]
