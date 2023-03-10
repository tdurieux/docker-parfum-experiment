# Dockerfile
FROM python:3.7
RUN mkdir /web
WORKDIR /web
COPY setup.py requirements_dev.txt requirements.txt /web/
RUN pip install --no-cache-dir -r requirements_dev.txt
COPY . /web/

EXPOSE 8001
CMD ["python", "manage.py", "runserver", "0.0.0.0:8001"]