FROM python:3.7.3-slim
RUN apt-get update
RUN apt-get install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends default-libmysqlclient-dev -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir mysqlclient
RUN pip install --no-cache-dir sqlalchemy
ADD python_task.py /
ADD util/* /util/
ENTRYPOINT ["python","/python_task.py"]
CMD []
