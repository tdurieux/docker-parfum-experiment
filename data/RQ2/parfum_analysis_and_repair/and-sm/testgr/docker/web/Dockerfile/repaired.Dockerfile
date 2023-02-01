# Pull Python base image
FROM python:3.10.4

# Set environment varibles
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set work directory
WORKDIR /code

# Install dependencies
RUN pip install --no-cache-dir --upgrade pip

# Copy requirements file
COPY requirements.txt /code

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt
