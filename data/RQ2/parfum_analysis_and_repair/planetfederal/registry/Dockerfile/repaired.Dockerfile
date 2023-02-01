FROM python:3.5

RUN apt-get update && apt-get install --no-install-recommends -y \
                libgeos-dev \
                && rm -rf /var/lib/apt/lists/*

RUN mkdir /code

WORKDIR /code

ADD . /code/

RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir psycopg2

EXPOSE 8000

CMD ["python", "registry.py", "runserver", "0.0.0.0:8000"]