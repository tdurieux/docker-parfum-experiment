FROM python:3.8 as pythonbuild1
RUN pip install --no-cache-dir Flask

LABEL maintainer="desislava@scaleoutsystems.com"

RUN mkdir /app
RUN mkdir /app/work
COPY requirements.txt /app
RUN pip install --no-cache-dir -r /app/requirements.txt

FROM pythonbuild1

COPY . /app
WORKDIR /app

ENV PROJECT_DIR .

ENTRYPOINT ["python"]
CMD ["serve.py"]
