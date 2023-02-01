FROM tiangolo/uwsgi-nginx-flask:python3.8

COPY ./app /app

COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir greenlet==0.4.17
