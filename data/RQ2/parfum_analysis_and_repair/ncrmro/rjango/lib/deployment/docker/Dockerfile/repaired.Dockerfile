FROM ncrmro/adbase:alpine

ENV INSTALL_PATH=/reango \
    BUILD_PACKAGES="apt-transport-https python-software-properties" \
    DJANGO_SETTINGS_MODULE=reango.settings.prod \
    SECRET_KEY=000000000000000 \
    DATABASE_URL=sqlite:////src/db.sqlite3 \
    ALLOWED_HOSTS=['*']

WORKDIR $INSTALL_PATH

# Copy python requirements these layers only get ran if anything changes.
COPY ./requirements.txt $INSTALL_PATH

COPY ./lib $INSTALL_PATH/lib

RUN pip3 install --no-cache-dir -r $INSTALL_PATH/requirements.txt -r

COPY . $INSTALL_PATH

RUN yarn \
    && python3 ./manage.py collectstatic --no-input \
    && rm -rf ./node_modules && yarn cache clean;

EXPOSE 8000

ENTRYPOINT ["python3", "-u"]