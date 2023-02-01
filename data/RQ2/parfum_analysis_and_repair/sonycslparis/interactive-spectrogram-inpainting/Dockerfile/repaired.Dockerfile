# syntax=docker/dockerfile:experimental

FROM pytorch/pytorch:1.12.0-cuda11.3-cudnn8-runtime

# libsndfile1 used for torchaudio
# curl used for container self-health checks (e.g. on AWS ECS)
RUN apt update -yq && apt install --no-install-recommends -yqq \
  libsndfile1 \
  curl \
  && rm -rf /var/lib/apt/lists/*

COPY ./requirements/requirements-main-unfreeze.txt .
RUN conda install -c pytorch -c conda-forge --yes --freeze-installed torchaudio --file ./requirements-main-unfreeze.txt \
  && conda clean -afy

# TODO(@tbazin): do not store models within the container,
# retrieve them at runtime from static remote storage
COPY ./scripted_models/20220703/vqvae/20200309-220303-d006ab/vqvae_nsynth_436.pt \
  scripted_models/vqvae.pt
COPY ./scripted_models/20220703/vqvae-20200309-220303-d006ab/transformer-bottom/transformer_bottom-20200512-165540-9964e5.pt \
  scripted_models/transformer_bottom.pt
COPY ./scripted_models/20220703/vqvae-20200309-220303-d006ab/transformer-top/transformer_top-20200513-231538-0bd9f5.pt \
  scripted_models/transformer_top.pt

COPY flask_server.py flask_default_config.cfg sample.py ./


EXPOSE 8000
ENV PYTHONUNBUFFERED=true
ENTRYPOINT ["gunicorn", "--bind=:8000", "--timeout=30", "flask_server:create_app()"]