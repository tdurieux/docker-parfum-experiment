FROM python:3.6
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir .
#RUN pip install git+https://github.com/BaderLab/saber.git
RUN pip install --no-cache-dir git+https://www.github.com/keras-team/keras-contrib.git
RUN pip install --no-cache-dir https://github.com/huggingface/neuralcoref-models/releases/download/en_coref_md-3.0.0/en_coref_md-3.0.0.tar.gz
CMD ["python", "-m", "saber.cli.app"]
EXPOSE 5000
