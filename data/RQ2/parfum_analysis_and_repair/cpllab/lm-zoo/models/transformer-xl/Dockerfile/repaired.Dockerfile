FROM cpllab/language-models:pytorch-transformers

ARG MODEL_ROOT=models/transformer-xl

RUN mkdir -p /opt/pytorch-transformers/models/transfo-xl-wt103
RUN cd /opt/pytorch-transformers/models/transfo-xl-wt103 && \
        curl -f -so vocab.bin https://s3.amazonaws.com/models.huggingface.co/bert/transfo-xl-wt103-vocab.bin && \
        curl -f -so pytorch_model.bin https://s3.amazonaws.com/models.huggingface.co/bert/transfo-xl-wt103-pytorch_model.bin && \
        curl -f -so config.json https://s3.amazonaws.com/models.huggingface.co/bert/transfo-xl-wt103-config.json

ENV PYTORCH_TRANSFORMER_MODEL_TYPE transfo-xl
ENV PYTORCH_TRANSFORMER_MODEL_PATH /opt/pytorch-transformers/models/transfo-xl-wt103

# Set up override tokenizer.
RUN pip install --no-cache-dir nltk
RUN rm -rf /opt/bin
COPY ${MODEL_ROOT}/bin /opt/bin
