FROM python:3.6
ENV PYTHONUNBUFFERED 1
ENV C_FORCE_ROOT True
ADD requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
