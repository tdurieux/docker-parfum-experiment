FROM daocloud.io/quantaxis/qawebserver:latest
USER root

RUN cd /root \
&& git clone https://github.com/yutiansut/QATrader \
&& pip install --no-cache-dir quantaxis -U \
&& pip install --no-cache-dir qaenv \
&& pip install --no-cache-dir tornado==5.1.1 \
&& pip install --no-cache-dir quantaxis-otgbroker -U \
&& cd QATrader && pip install --no-cache-dir -e . \
&& chmod +x /root/QATrader/docker/wait_for_it.sh \
&& sed -i "s|localhost|$MONGODB|" /usr/local/lib/python3.6/site-packages/QUANTAXIS/QAUtil/QASetting.py

EXPOSE 8020
