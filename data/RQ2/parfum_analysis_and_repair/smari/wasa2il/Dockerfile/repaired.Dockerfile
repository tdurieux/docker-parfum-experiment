# Usage:
#   docker build -t wasa2il .
#   docker run -it -p 8000:8000 wasa2il
FROM python:2-onbuild

RUN apt-get update && apt-get install -y --no-install-recommends tofrodos && rm -rf /var/lib/apt/lists/*;
RUN fromdos initial_setup.py
RUN fromdos wasa2il/manage.py

CMD ./initial_setup.py && cd wasa2il && ./manage.py runserver $(hostname -i):8000
