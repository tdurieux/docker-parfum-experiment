FROM wildfish/django

ONBUILD COPY requirements.txt /usr/src/app/
ONBUILD RUN pip install --no-cache-dir -r requirements.txt

ONBUILD COPY package.json /usr/src/app/
 \
RUN npm install --unsafe-perm=true && npm cache clean --force; ONBUILD

ONBUILD COPY . /usr/src/app

ONBUILD RUN chown -R django:django /usr/src/app/
ONBUILD USER django

ONBUILD RUN ./scripts/build-static.sh
ONBUILD RUN python manage.py collectstatic --noinput
