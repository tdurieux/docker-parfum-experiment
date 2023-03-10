FROM andrejreznik/python-gdal

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /code

COPY requirements.txt /code/

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir gunicorn

COPY . /code/

EXPOSE 8000

CMD ["gunicorn", "--workers", "1", "--bind", ":8000", "--log-level", "INFO", "cykel.wsgi:application"]
