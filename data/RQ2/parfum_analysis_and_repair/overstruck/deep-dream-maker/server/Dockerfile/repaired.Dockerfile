# FROM bvlc/caffe:cpu
FROM bvlc/caffe:cpu

WORKDIR /app
COPY requirements.txt requirements.txt
# install dependencies
RUN pip install --no-cache-dir -r requirements.txt
#COPY . .
WORKDIR src

ENV FLASK_APP=app
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_ENV=development
ENV FLASK_DEBUG=1

CMD ["flask", "run"]
