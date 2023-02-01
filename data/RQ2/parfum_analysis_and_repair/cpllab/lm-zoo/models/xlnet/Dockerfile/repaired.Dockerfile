FROM cpllab/language-models:pytorch-transformers

RUN pip install --no-cache-dir sentencepiece

RUN mkdir -p /opt/pytorch-transformers/models/xlnet
RUN cd /opt/pytorch-transformers/models/xlnet && \
        curl -f -so spiece.model https://s3.amazonaws.com/models.huggingface.co/bert/xlnet-base-cased-spiece.model && \
        curl -f -so pytorch_model.bin https://s3.amazonaws.com/models.huggingface.co/bert/xlnet-base-cased-pytorch_model.bin && \
        curl -f -so config.json https://s3.amazonaws.com/models.huggingface.co/bert/xlnet-base-cased-config.json

ENV PYTORCH_TRANSFORMER_MODEL_TYPE xlnet
ENV PYTORCH_TRANSFORMER_MODEL_PATH /opt/pytorch-transformers/models/xlnet
