FROM python:3.6
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y libpq-dev python3-dev binutils libproj-dev gdal-bin netcat && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -U pip setuptools

COPY requirements.txt /app/

RUN pip install --no-cache-dir -r /app/requirements.txt

ADD . /app/

EXPOSE 8000

ENTRYPOINT ["/app/entrypoint.sh"]