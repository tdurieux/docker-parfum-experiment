FROM python:3.7

ADD ./scraper /app
ADD ./python_common /app/src/python_common
WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt

CMD ["./run_worker.sh"]
