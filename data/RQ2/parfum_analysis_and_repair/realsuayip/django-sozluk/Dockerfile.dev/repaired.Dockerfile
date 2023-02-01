FROM python:3.8.12
ENV PYTHONUNBUFFERED 1

RUN mkdir /code
WORKDIR /code
COPY requirements.txt /code/

RUN apt-get update && apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r requirements.txt
COPY . /code/

ENTRYPOINT ["/code/scripts/entrypoint.dev.sh"]
