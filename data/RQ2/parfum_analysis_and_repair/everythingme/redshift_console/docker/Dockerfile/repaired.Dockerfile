FROM python:2.7

RUN pip install --no-cache-dir -U redshift-console==0.1.3
EXPOSE 5000

CMD [ "redshift-console", "runserver" ]
