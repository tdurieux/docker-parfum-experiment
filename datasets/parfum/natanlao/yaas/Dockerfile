FROM tiangolo/uvicorn-gunicorn-starlette:python3.9-slim
# Dokku-specific fixes
ENV FORWARDED_ALLOW_IPS='*'
ENV PORT=80
EXPOSE 80

COPY requirements.txt /app
RUN pip install -r /app/requirements.txt
COPY templates/ /app/templates
COPY yaas.py /app/main.py
