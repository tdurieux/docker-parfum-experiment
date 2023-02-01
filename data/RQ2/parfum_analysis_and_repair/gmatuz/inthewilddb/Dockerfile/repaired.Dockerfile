FROM python:alpine
COPY requirements.txt inthewild.db src/main.py ./
RUN pip install --no-cache-dir -r requirements.txt
ENTRYPOINT ["python", "main.py"]
