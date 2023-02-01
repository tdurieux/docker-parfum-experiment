FROM python:3.6

ENTRYPOINT ["./docker-entrypoint.sh"]
EXPOSE 5000

RUN apt-get update && apt-get install --no-install-recommends -y libsnappy-dev && rm -rf /var/lib/apt/lists/*;

# Working directory
RUN mkdir -p /app
WORKDIR /app

# Apache Airflow
ENV AIRFLOW_GPL_UNIDECODE yes

# Install the Python requirements
ADD requirements.txt /app/
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir python-snappy==0.5.4
RUN pip install --no-cache-dir -r requirements.txt

# Copy the source files
COPY . /app
