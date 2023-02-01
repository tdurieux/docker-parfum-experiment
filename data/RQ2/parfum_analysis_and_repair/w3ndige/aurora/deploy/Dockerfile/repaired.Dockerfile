FROM tiangolo/uvicorn-gunicorn-fastapi:python3.8
ENV MODULE_NAME=aurora.app
RUN apt-get update && apt-get install --no-install-recommends -y libmagic-dev libfuzzy-dev libfuzzy2 && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt setup.py alembic.ini karton.ini prestart.sh ./
COPY ./aurora ./aurora
RUN pip install --no-cache-dir .
