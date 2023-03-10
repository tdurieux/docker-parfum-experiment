FROM python:3.7

RUN pip install --no-cache-dir httpx PyGithub "pydantic==1.5.1"

COPY ./app /app

CMD ["python", "/app/main.py"]
