FROM python:3-alpine

LABEL maintainer="moimog33@gmail.com"

COPY ./app /app

WORKDIR /app

RUN pip install --no-cache-dir --upgrade pip \
  && pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

ENTRYPOINT ["python"]

CMD ["main.py"]
