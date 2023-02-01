FROM python:3-alpine
WORKDIR /service
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . ./
EXPOSE 5000
ENTRYPOINT ["python3", "qotm/qotm.py"]
