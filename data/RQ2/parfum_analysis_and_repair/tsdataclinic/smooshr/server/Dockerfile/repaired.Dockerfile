FROM python:3.6

WORKDIR /app
ADD requirements.txt /app

RUN pip install --no-cache-dir Flask Flask-RESTful gensim
RUN pip install --no-cache-dir scikit-learn --upgrade
RUN pip install --no-cache-dir scipy --upgrade
Run pip install --no-cache-dir sklearn --upgrade
RUN pip install --no-cache-dir redis

RUN pip install --no-cache-dir flask-restful
RUN pip install --no-cache-dir flask-cors

RUN pip install --no-cache-dir celery
RUN pip install --no-cache-dir psycopg2
RUn pip install --no-cache-dir flask_sqlalchemy
COPY . /app

ENTRYPOINT ["python"]

CMD ["server.py"]

