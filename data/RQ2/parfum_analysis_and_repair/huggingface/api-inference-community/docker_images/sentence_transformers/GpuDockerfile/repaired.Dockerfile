FROM tiangolo/uvicorn-gunicorn:python3.9 as builder


FROM nvcr.io/nvidia/pytorch:21.02-py3
LABEL maintainer="Nicolas Patry <nicolas@huggingface.co>"
COPY --from=builder /start.sh /
COPY --from=builder /gunicorn_conf.py /
COPY --from=builder /app /
# Necessary on GPU environment docker
# /etc/shinit_v2 somehow overwrites TIMEOUT env variable, so we rename them UV_TIMEOUT
# To distinguish the UVICORN TIMEOUT variable.
RUN sed -i 's/TIMEOUT/UV_TIMEOUT/g' /gunicorn_conf.py

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York
RUN apt-get update -y && apt-get install --no-install-recommends libsndfile1 ffmpeg -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir uvloop gunicorn httptools uvicorn
RUN ln -fs /usr/share/zoneinfo/Europe/Dublin /etc/localtime

WORKDIR /app/
RUN pip3 install --no-cache-dir torch==1.12.0 --extra-index-url https://download.pytorch.org/whl/cu116
COPY ./requirements.txt /app/
RUN pip install --no-cache-dir -r /app/requirements.txt

ENV HUGGINGFACE_HUB_CACHE=/data
ENV SENTENCE_TRANSFORMERS_HOME=/data
ENV TRANSFORMERS_CACHE=/data


# This is model downloading. Put it *before* copying the source files
# that means later builds will be cached if you don't change this one file
# which should not happen very often
COPY ./prestart.sh /app/

ENV PYTHONPATH "${PYTHONPATH}:/app/"
ARG model_id
ENV MODEL=$model_id
RUN echo $MODEL

ARG max_workers=1
ENV MAX_WORKERS=$max_workers

COPY ./app /app/app


ENV PYTHONPATH=/app

EXPOSE 80

# Run the start script, it will check for an /app/prestart.sh script (e.g. for migrations)
# And then will start Gunicorn with Uvicorn
CMD ["/start.sh"]
