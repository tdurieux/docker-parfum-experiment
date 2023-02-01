FROM python:3.7
ENV DEBIAN_FRONTEND noninteractive

COPY . /htools-api

WORKDIR /htools-api

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt && pip install --no-cache-dir --upgrade requests
RUN pip install --no-cache-dir -e .

EXPOSE 8000

CMD ["gunicorn", "--workers=2", "--bind=0.0.0.0:8000", "--reload", "healthtools.manage:app"]
