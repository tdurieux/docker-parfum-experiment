FROM python:3.6

WORKDIR /app
COPY . /app


RUN apt-get -y update && apt-get -y install --no-install-recommends binutils && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r /app/requirements.txt

RUN ./generate-django.sh


CMD ./run_migrate.sh