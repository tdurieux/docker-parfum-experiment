FROM bvlc/caffe:cpu
WORKDIR /app
# install dependencies
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
# setup enviroment
EXPOSE 5000

WORKDIR src

ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_ENV=production
ENV FLASK_DEBUG=False

CMD [ "gunicorn", "--config", "gunicorn/config.py", "wsgi:server"]
