FROM python:3.6

RUN pip install --no-cache-dir cython
RUN pip install --no-cache-dir gunicorn meinheld falcon
ADD app_falcon.py app.py
ENTRYPOINT ["gunicorn", "--workers=8", "--worker-class=meinheld.gmeinheld.MeinheldWorker", "-b0.0.0.0:8000", "app:app"]
