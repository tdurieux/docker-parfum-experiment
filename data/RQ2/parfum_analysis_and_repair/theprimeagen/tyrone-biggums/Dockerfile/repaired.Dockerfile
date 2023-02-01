FROM python:latest AS PY
WORKDIR /app
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r ./requirements.txt
ENV FILE=./analysis.csv
CMD ["python3", "main.py"]



