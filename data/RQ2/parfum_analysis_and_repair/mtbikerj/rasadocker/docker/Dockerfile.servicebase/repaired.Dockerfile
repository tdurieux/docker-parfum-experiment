FROM python:3
COPY docker/requirements_service.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
