FROM python:3.7-stretch
MAINTAINER sih4sing5hong5

RUN pip install --no-cache-dir tai5-uan5_gian5-gi2_kang1-ku7

RUN apt-get update -qq && \
   apt-get install --no-install-recommends -y cmake libboost-all-dev && rm -rf /var/lib/apt/lists/*;
RUN echo 'from 臺灣言語工具.語言模型.安裝KenLM訓練程式 import 安裝KenLM訓練程式; 安裝KenLM訓練程式.安裝kenlm()' | python
COPY --from=sih4sing5hong5/mosesdecoder:docker /usr/local/mosesserver/bin/mosesserver /usr/local/lib/python3.7/site-packages/外部程式/mosesserver
