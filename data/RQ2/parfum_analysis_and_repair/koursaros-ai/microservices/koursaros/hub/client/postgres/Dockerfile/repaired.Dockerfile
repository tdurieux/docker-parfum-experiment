FROM gnes/gnes:latest-buster

RUN apt update && apt install --no-install-recommends libpq-dev gcc python3-dev musl-dev git -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir psycopg2 git+https://git@github.com/koursaros-ai/koursaros.git

ADD *.py *.yml ./

ENTRYPOINT ["python", "postgres.py", "--start_doc_id", "1"]