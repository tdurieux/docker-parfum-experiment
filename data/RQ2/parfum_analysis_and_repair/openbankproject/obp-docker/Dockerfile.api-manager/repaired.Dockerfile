FROM debian:buster
RUN apt-get update && apt-get install -y --no-install-recommends python3 python3-virtualenv python3-psycopg2 git && rm -rf /var/lib/apt/lists/*;

WORKDIR API-Manager
RUN pwd
RUN git clone https://github.com/OpenBankProject/API-Manager.git

ENV VIRTUAL_ENV=venv
RUN python3 -m virtualenv --python=/usr/bin/python3 $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

#COPY API-Manager/requirements.txt .
#RUN pwd && ls && ls API-Manager
COPY /api-manager/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY /api-manager/local_settings.py API-Manager/apimanager/apimanager/local_settings.py
#RUN pwd && ls API-Manager
RUN API-Manager/apimanager/manage.py check
RUN API-Manager/apimanager/manage.py makemigrations
RUN API-Manager/apimanager/manage.py migrate
CMD ["API-Manager/apimanager/manage.py", "runserver", "0.0.0.0:8000"]
