FROM python:3.8.3-slim
RUN apt update
RUN apt install --no-install-recommends curl gettext sqlite3 build-essential -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt install --no-install-recommends nodejs -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update
RUN apt install --no-install-recommends yarn -y && rm -rf /var/lib/apt/lists/*;

RUN mkdir jam
WORKDIR jam
COPY . /jam/
RUN pip install --no-cache-dir -r requirements.txt gunicorn uvicorn
RUN yarn install && yarn cache clean;
RUN yarn build && yarn cache clean;
RUN sqlite3 db.sqlite3
ENV DJANGO_SECRET_KEY=$(dbus-uuidgen)
RUN python manage.py migrate
RUN python manage.py collectstatic --noinput
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 lammas.asgi -k uvicorn.workers.UvicornWorker
