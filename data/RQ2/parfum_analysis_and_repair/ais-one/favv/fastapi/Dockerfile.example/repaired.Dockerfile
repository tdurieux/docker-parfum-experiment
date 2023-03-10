FROM python:3.8

EXPOSE 3000

COPY . .

RUN ls /app

RUN apt-get update && apt-get -y install --no-install-recommends libxmlsec1-dev pkg-config && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y upgrade

# RUN /usr/local/bin/python -m pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.base.txt
RUN pip install --no-cache-dir -r app/custom_app/requirements.txt

# COPY ./app /app
WORKDIR /app

# run only fastapi
# CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

# run both fastapi and huey
# CMD uvicorn main:app --host 0.0.0.0 --port 3000 & huey_consumer custom_app.models.tasks.huey
# run both fastapi only
CMD uvicorn main:app --host 0.0.0.0 --port 3000
