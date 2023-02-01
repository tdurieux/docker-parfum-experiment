FROM python:3

# Creates the directory for us
WORKDIR /guya
COPY ./requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
