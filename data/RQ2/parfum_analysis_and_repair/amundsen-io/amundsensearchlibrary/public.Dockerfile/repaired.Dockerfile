FROM python:3.7-slim
WORKDIR /app
RUN pip3 install --no-cache-dir gunicorn

COPY requirements.txt /app/requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . /app
RUN python3 setup.py install

CMD [ "python3", "search_service/search_wsgi.py" ]
