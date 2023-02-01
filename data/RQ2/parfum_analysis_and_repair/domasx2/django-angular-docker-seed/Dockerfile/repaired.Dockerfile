FROM python:3.5

RUN apt-get update && apt-get install --no-install-recommends -y gettext && rm -rf /var/lib/apt/lists/*;

ADD requirements.txt /requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt
RUN mkdir static

VOLUME ["/static"]

WORKDIR /src
EXPOSE 8000
ENTRYPOINT ["python3", "manage.py"]
CMD ["runserver", "0.0.0.0:8000"]