FROM python
RUN apt-get update && apt-get install --no-install-recommends --fix-missing -y locales python3-pip python3-dev build-essential git && rm -rf /var/lib/apt/lists/*;

ADD ./app /app/
WORKDIR /app/

RUN pip3 install --no-cache-dir -r /app/requirements.txt

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "wsgi:app"]