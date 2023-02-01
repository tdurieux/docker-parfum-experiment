FROM gcr.io/production-deployment/base-web:latest

WORKDIR /app/
# Copied separately to allow for caching of the `pip install` build step
COPY requirements.txt /app/requirements.txt
RUN pip3 install --no-cache-dir -r /app/requirements.txt --use-feature=2020-resolver

COPY package*.json /app/
RUN npm install --unsafe-perm && npm cache clean --force;

COPY ./node /app/node
COPY ./static/js /app/static/js
RUN npm run build-prod

COPY . /app/

RUN python manage.py collectstatic

ENTRYPOINT ["/bin/bash", "-c"]
EXPOSE 80
