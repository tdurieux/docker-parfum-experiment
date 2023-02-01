FROM laudio/pyodbc:latest

WORKDIR /app

# Copy code to container
COPY . .
RUN pip install --no-cache-dir -r requirements.txt
CMD ["python", "main.py"]
