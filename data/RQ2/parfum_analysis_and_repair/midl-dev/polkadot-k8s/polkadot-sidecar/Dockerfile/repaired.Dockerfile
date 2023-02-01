FROM python:alpine
WORKDIR /build
COPY . /build
ENV PYTHONUNBUFFERED=1
RUN pip install --no-cache-dir -r requirements.txt
ENTRYPOINT ["gunicorn", "-b", ":31764", "wsgi" ]
