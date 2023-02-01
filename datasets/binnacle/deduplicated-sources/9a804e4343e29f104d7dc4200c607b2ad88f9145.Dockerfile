FROM python:3.7.2

WORKDIR /usr/src/app

COPY requirements.txt settings.py ./
COPY app app

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 3000

CMD gunicorn --log-level warning --bind 0.0.0.0:3000 --reuse-port --workers $(nproc) --worker-class meinheld.gmeinheld.MeinheldWorker app.wsgi
