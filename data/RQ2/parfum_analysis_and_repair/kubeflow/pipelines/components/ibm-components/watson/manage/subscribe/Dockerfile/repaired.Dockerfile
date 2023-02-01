FROM python:3.6.8-stretch

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --upgrade watson-machine-learning-client ibm-ai-openscale Minio --no-cache | tail -n 1
RUN pip install --no-cache-dir psycopg2-binary | tail -n 1

ENV APP_HOME /app
COPY src $APP_HOME
WORKDIR $APP_HOME

ENTRYPOINT ["python"]
CMD ["subscribe.py"]
