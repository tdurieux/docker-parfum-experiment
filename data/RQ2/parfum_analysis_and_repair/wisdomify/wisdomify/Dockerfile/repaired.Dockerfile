# Base python image Build
FROM python:3.9-buster

WORKDIR /wisdomify
COPY . .
COPY requirements.txt /wisdomify/

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Deploy
EXPOSE 8080
CMD ["python3", "main_deploy.py", "--model", "rd_beta", "--ver", "b"]