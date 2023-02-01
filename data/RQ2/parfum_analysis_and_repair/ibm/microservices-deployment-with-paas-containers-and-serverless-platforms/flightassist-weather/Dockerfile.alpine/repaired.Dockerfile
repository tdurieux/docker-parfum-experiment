FROM python:2.7-alpine

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -U setuptools
RUN pip install --no-cache-dir Flask Flask-Cache requests

# application source code including static files, templates, etc
ADD src /app/src

EXPOSE 5000
ENTRYPOINT ["python", "-u", "/app/src/app.py"]
