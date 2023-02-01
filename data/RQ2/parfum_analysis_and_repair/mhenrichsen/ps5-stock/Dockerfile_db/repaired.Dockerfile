FROM python:3.7

RUN pip install --no-cache-dir uvicorn fastapi aiofiles

WORKDIR /app

COPY database.py /app

COPY sql.db /app

CMD ["python", "database.py"]