FROM nvcr.io/nvidia/pytorch:20.12-py3

ENTRYPOINT bash

RUN apt update && apt-get -y --no-install-recommends install default-libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;

# Don't just use the requirements file and install torch etc.... the nvidia image already
# comes with a pre-installed torch etc, so installing another torch/pytorch (and also the transitive torch dependency of transformers for example)
# will cause quite a bit of trouble.
RUN pip install --no-cache-dir nltk
RUN pip install --no-cache-dir tqdm
RUN pip install --no-cache-dir pattern
RUN pip install --no-cache-dir transformers
RUN pip install --no-cache-dir pytictoc
RUN pip install --no-cache-dir wandb
RUN pip install --no-cache-dir pyyaml
RUN pip install --no-cache-dir word2number
RUN pip install --no-cache-dir sqlparse
RUN pip install --no-cache-dir "textdistance[extras]"
RUN pip install --no-cache-dir spacy
# in contrary to the pipfile we need some binaries for postgres too.
RUN pip install --no-cache-dir psycopg2-binary
RUN pip install --no-cache-dir flask
RUN pip install --no-cache-dir flask-cors

COPY src /workspace/src
COPY data /workspace/data
COPY models /workspace/models

RUN python src/tools/download_nltk.py
RUN python -m spacy download en_core_web_sm

ENV PYTHONPATH /workspace/src

WORKDIR /workspace

ENV API_KEY 1234
ENV MODEL_TO_LOAD models/best_model.pt
ENV DB_HOST localhost
ENV DB_PORT 5432
ENV DB_USER postgres
ENV DB_PW dummy
ENV DB_SCHEMA public
ENV NER_API_SECRET PLEASE_ADD_YOUR_OWN_GOOGLE_API_KEY_HERE

ENTRYPOINT python src/manual_inference/manual_inference_api.py --api_key=$API_KEY --model_to_load=$MODEL_TO_LOAD --ner_api_secret=$NER_API_SECRET --database_host=$DB_HOST --database_port=$DB_PORT --database_user=$DB_USER --database_password=$DB_PW --database_schema=$DB_SCHEMA
