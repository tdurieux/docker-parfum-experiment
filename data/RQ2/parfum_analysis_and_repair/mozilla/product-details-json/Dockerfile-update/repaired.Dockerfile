FROM python:3.6-slim

# Set Python-related environment variables to reduce annoying-ness
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
ENV PIP_DISABLE_PIP_VERSION_CHECK 1
ENV LANG C.UTF-8

WORKDIR /app
CMD ["./update-product-details.py"]

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY update-product-details.py ./
