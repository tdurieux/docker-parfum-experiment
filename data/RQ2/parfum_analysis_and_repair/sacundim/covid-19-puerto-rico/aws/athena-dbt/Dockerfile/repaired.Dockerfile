FROM python:3.9-slim

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install pipx
RUN pipx install dbt-core
RUN pipx inject dbt-core git+https://github.com/Tomme/dbt-athena.git
WORKDIR /covid-19-puerto-rico/aws/
COPY ./ athena-dbt/
WORKDIR /covid-19-puerto-rico/aws/athena-dbt/
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["./run-models.sh"]