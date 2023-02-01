FROM python:3.7
COPY . /app
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
CMD ["python3.7", "phishing_catcher.py"]
