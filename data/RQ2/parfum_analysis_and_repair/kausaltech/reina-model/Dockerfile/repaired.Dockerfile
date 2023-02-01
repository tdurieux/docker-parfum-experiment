FROM python:3.8

RUN apt update && apt install --no-install-recommends -y libfreetype6-dev libpng-dev libqhull-dev pkg-config \
    gcc gfortran libopenblas-dev liblapack-dev cython && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app /src
WORKDIR /app

COPY requirements.txt requirements-prod.txt /app/
RUN pip install --no-cache-dir -r requirements.txt -r

COPY . /app
COPY ./docker/docker-entrypoint.sh /

RUN export PYTHONPATH="${PYTHONPATH}:/src"
RUN pybabel compile -d locale
RUN python -m cythonsim.build

EXPOSE 5000
ENTRYPOINT ["/bin/sh", "/docker-entrypoint.sh"]
