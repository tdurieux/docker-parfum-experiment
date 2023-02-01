FROM continuumio/anaconda3
RUN apt-get update && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir gensim==2.2.0 scikit-learn==0.18.1 beautifulsoup4==4.5.3

ADD ./altair/flask_demo/vectorize_python_script_folder.py /altair/
ADD ./altair/models /altair/models/
ADD ./altair/util /altair/altair/util/
WORKDIR /altair
ENV PYTHONPATH /altair:$PYTHONPATH
ENTRYPOINT ["/opt/conda/bin/python3","vectorize_python_script_folder.py"]
CMD ["/altair/models/doc2vec_trainedmodel_cbow_docs1200000_negative10_epochs20_mincount1200.pkl","/in","/out/script_vectors.pkl"]