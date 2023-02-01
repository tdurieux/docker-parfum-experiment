FROM python:3
WORKDIR /covidapi
COPY requirements.txt requirements-test.txt /covidapi/
RUN pip install --no-cache-dir -r /covidapi/requirements.txt -r

CMD ["uvicorn", "covidapi.app:app", "--host", "0.0.0.0", "--reload"]
