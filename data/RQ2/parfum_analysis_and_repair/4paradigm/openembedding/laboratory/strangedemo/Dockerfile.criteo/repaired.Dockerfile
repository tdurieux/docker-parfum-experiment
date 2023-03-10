FROM openembedding-demo:2.2
ADD train.csv /root/train.csv
ADD dac_sample.csv /root/dac_sample.csv
ADD laboratory/strangedemo/criteo_predict.py /root/criteo_predict.py
ADD laboratory/strangedemo/criteo_deepctr /root/criteo_deepctr
ADD laboratory/strangedemo/criteo_deepctr_np /root/criteo_deepctr_np
ADD laboratory/strangedemo/criteo_lr /root/criteo_lr

RUN ln -s /root/train.csv /root/criteo_deepctr/train.csv && \
    ln -s /root/dac_sample.csv /root/criteo_deepctr/dac_sample.csv && \
    ln -s /root/criteo_predict.py /root/criteo_deepctr/criteo_predict.py 

RUN ln -s /root/train.csv /root/criteo_deepctr_np/train.csv && \
    ln -s /root/dac_sample.csv /root/criteo_deepctr_np/dac_sample.csv && \
    ln -s /root/criteo_predict.py /root/criteo_deepctr_np/criteo_predict.py 

RUN ln -s /root/train.csv /root/criteo_lr/train.csv && \
    ln -s /root/dac_sample.csv /root/criteo_lr/dac_sample.csv && \
    ln -s /root/criteo_predict.py /root/criteo_lr/criteo_predict.py 
WORKDIR /root