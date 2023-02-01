FROM python:3.9
RUN apt-get -y update && apt-get -y --no-install-recommends install libprotobuf17 python-pkg-resources python-protobuf python-six && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir mysql-connector

ADD . /application
WORKDIR /application
RUN pip install --no-cache-dir -r requirements.txt
CMD ["uwsgi", "--http", ":5000",  "--mount", "/myapplication=app:app", "--processes", "10"]