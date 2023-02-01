FROM tiangolo/uvicorn-gunicorn-fastapi:python3.7
COPY ./requirements.txt /app/
RUN pip install --no-cache-dir spacy
RUN pip install --no-cache-dir -r requirements.txt
RUN ./scripts/download_models.sh
COPY ./scripts /app/app
