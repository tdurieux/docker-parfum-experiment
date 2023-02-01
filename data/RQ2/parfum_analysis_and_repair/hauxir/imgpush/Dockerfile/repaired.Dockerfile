FROM python:3.6-slim

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    libmagickwand-dev curl \
    nginx && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt .
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY ImageMagick-6/policy.xml /etc/ImageMagick-6/policy.xml

RUN pip install --no-cache-dir -r requirements.txt

RUN mkdir /images
RUN mkdir /cache

EXPOSE 5000

COPY app /app

WORKDIR /app

CMD bash entrypoint.sh
