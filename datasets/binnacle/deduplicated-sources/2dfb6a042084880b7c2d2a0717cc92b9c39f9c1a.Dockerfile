FROM b.gcr.io/airflow-gcp/airflow-master:1.8.0.ga.101

RUN pip install slackclient
RUN pip install SurveyGizmo
RUN pip install elasticsearch
#RUN wget https://downloads.tableau.com/tssoftware/Tableau-SDK-Python-Linux-64Bit-10-1-3.tar.gz \
#    && tar xvf Tableau-SDK-Python-Linux-64Bit-10-1-3.tar.gz \
#    && cd TableauSDK-10100.16.1223.0056 \
#    && python setup.py install \
#    && cd .. \
#    && rm -rf TableauSDK-10100.16.1223.0056 \
#    && rm -rf Tableau-SDK-Python-Linux-64Bit-10-1-3.tar.gz
