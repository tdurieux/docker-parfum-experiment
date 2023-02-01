FROM continuumio/anaconda3
RUN apt-get update && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir gensim==2.2.0 scikit-learn==0.18.1 beautifulsoup4==4.5.3

ADD . /altair/
WORKDIR /altair
ENV PYTHONPATH /altair:$PYTHONPATH
EXPOSE 5000
ENTRYPOINT ["/opt/conda/bin/python3","altair/flask_demo/app.py"]
CMD ["/altair/altair/models/doc2vec_trainedmodel_cbow_docs1200000_negative10_epochs20_mincount1200.pkl","/altair/altair/models/github/python_vectors_1Mmodel_200kvectors.pkl"]
