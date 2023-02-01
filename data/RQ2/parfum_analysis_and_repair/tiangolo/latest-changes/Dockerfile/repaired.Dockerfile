FROM python:3.7

COPY ./requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir -r /app/requirements.txt

COPY ./latest_changes /app/latest_changes

ENV PYTHONPATH=/app

CMD ["python", "-m", "latest_changes"]
