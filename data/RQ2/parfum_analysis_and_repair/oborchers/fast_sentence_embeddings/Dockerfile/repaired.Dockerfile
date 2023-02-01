FROM python:3.6.0

RUN pip install --no-cache-dir -U pip

RUN pip install --no-cache-dir scipy \
    smart_open \
    scikit-learn \
    wordfreq \
    huggingface-hub \
    psutil

ARG gensim==4.0.0
RUN pip install --no-cache-dir -U "gensim==$gensim" pytest coverage

ADD . /home
WORKDIR /home
RUN rm -rf build dist

RUN pip install --no-cache-dir -e .

CMD [ "pytest", "-vv" ]