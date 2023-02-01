FROM python:3.9

USER root
WORKDIR /app
ADD . /app

RUN pip install --no-cache-dir --trusted-host pypi.python.org -r requirements.txt
CMD ["python", "app.py"]