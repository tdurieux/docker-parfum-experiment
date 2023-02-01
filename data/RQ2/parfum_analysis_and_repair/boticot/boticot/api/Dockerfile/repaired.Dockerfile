FROM python:3.6-slim

RUN pip install --no-cache-dir rasa==1.5.3
RUN pip install --no-cache-dir Tensorflow-datasets==1.3.0
RUN pip install --no-cache-dir Flask-PyMongo==2.3.0
RUN pip install --no-cache-dir flask==1.1.2
RUN pip install --no-cache-dir flask_cors==3.0.8
RUN pip install --no-cache-dir flask-compress==1.5.0
RUN pip install --no-cache-dir isodate==0.6.0
RUN pip install --no-cache-dir flask_jwt_extended==3.24.1
RUN pip install --no-cache-dir bcrypt==3.2.0
RUN pip install --no-cache-dir pytest==6.2.5
RUN pip install --no-cache-dir pytest-mock==3.6.1
RUN pip install --no-cache-dir gym==0.15.3

ADD . .

CMD ["python", "app.py"]