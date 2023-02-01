FROM python:3.6
RUN pip install --no-cache-dir gunicorn google-python-cloud-debugger
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
ADD . /code
WORKDIR /code
RUN pip install --no-cache-dir ./rws-common
ENV FLASK_ENV=production
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 appstore:app
