FROM python:3.7

WORKDIR /

COPY . .

RUN pip install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r requirements.lock

CMD uwsgi --ini uwsgi.ini
