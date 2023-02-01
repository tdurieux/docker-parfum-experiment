FROM python:2.7
ADD requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
ADD . /code
WORKDIR /code
CMD python app.py
