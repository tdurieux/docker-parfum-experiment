FROM python:3.7-slim

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir requests ruamel.yaml https://storage.googleapis.com/ml-pipeline/release/0.1.21/kfp.tar.gz ai_pipeline_params

ENV APP_HOME /app
COPY . $APP_HOME
WORKDIR $APP_HOME

ENTRYPOINT ["python"]
CMD ["start.py"]
