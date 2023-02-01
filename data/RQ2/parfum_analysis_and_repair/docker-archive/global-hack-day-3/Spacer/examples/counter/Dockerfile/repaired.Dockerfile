FROM python:2.7
ADD . /code
WORKDIR /code
RUN pip install --no-cache-dir -r requirements.txt
CMD python app.py
