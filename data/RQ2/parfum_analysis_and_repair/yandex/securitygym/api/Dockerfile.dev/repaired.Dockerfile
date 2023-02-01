FROM python:3.6

COPY src/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /app

EXPOSE 5000
CMD ["python", "run.py"]