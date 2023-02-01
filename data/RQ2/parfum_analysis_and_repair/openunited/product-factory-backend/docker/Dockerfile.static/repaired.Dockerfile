FROM python:3.9.7-buster as builder

COPY . /app
WORKDIR /app

RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt
RUN python manage.py collectstatic --noinput

FROM nginx:1.19.10-alpine

COPY --from=builder /app/staticfiles /usr/share/nginx/html/static
