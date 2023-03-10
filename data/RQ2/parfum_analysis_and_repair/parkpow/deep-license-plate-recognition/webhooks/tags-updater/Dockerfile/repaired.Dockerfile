FROM python:3.9.7
ENV PYTHONUNBUFFERED=1
WORKDIR /app
# Copy python dependecies file
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 8001
COPY . /app/

CMD ["python3", "main.py"]
