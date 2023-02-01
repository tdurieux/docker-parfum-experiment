FROM python:latest

WORKDIR /szbot
COPY . /szbot

RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python"]
CMD ["-m", "szbot"]
