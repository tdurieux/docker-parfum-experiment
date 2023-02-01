FROM python:3
WORKDIR app
COPY . .
RUN pip install --no-cache-dir config42


ENTRYPOINT ["python", "/app/app.py"]