# to run outside kubernetes....
# set up config file
# mount with -v PATH/TO/:/etc/omicidx
FROM python:3.7

COPY pyproject.toml pyproject.toml
COPY poetry.lock poetry.lock

RUN apt-get update && apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir poetry
RUN poetry config virtualenvs.create false
RUN poetry install --no-dev -n


RUN rm -rf /root/.ssh

ENV PATH=$PATH:/google-cloud-sdk/bin



ENV PORT=80
EXPOSE $PORT

COPY . .

CMD exec uvicorn  --host 0.0.0.0 --port $PORT workshop_orchestra.api:app
