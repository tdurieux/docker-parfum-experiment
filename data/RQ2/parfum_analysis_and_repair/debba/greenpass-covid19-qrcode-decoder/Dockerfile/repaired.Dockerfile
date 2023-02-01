FROM python:3.9

WORKDIR /app
RUN apt update && apt install --no-install-recommends -y libzbar-dev && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
EXPOSE 8000
ENV PRODUCTION=${PRODUCTION}
ENV GA_ID=${GA_ID}
ENV SHARETHIS_SCRIPT_SRC=${SHARETHIS_SCRIPT_SRC}
ENV APP_URL=${APP_URL}
ENTRYPOINT ["gunicorn", "-b", "0.0.0.0:8000", "-w", "2", "--access-logfile", "-", "app:app"]