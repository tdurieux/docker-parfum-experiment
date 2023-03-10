FROM deepspeech/base:0.9.3

RUN apt-get update && apt-get install -y --no-install-recommends \
		sox libsox-fmt-all \
		sudo \
		&& rm -rf /var/lib/apt/lists/*
ENV DS_DIR /DeepSpeech
ENV DS_RELEASE "0.9.3"
ARG model_language=it
ENV MODEL_LANGUAGE=$model_language
ENV HOMEDIR /root
WORKDIR $HOMEDIR

# Training stuff

# Use our tiny dataset for training
# ARG fast_train 1

ARG lm_alpha=0.0
ENV LM_ALPHA=$lm_alpha

ARG lm_beta=0.0
ENV LM_BETA=$lm_beta

# range for lm_optimizer. Default from DS Eng: 5,5,2400
ARG lm_evaluate_range=
ENV LM_EVALUATE_RANGE=$lm_evaluate_range

ARG batch_size=64
ARG n_hidden=2048
ARG epochs=30
ARG learning_rate=0.0001
ARG dropout=0.4
ARG early_stop=1
# es_epochs default: 25
ARG es_epochs=10
ARG amp=1
ARG max_to_keep=2

#Set to 1 if you want to just export your model from best ckpt
ARG only_export=0
ENV ONLY_EXPORT=$only_export

# transfer learning part
ARG transfer_learning=0
ARG drop_source_layers=1
ENV TRANSFER_LEARNING=$transfer_learning
ENV DROP_SOURCE_LAYERS=1

ENV BATCH_SIZE=$batch_size
ENV N_HIDDEN=$n_hidden
ENV EPOCHS=$epochs
ENV LEARNING_RATE=$learning_rate
ENV DROPOUT=$dropout
ENV EARLY_STOP=$early_stop
ENV ES_EPOCHS=$es_epochs
ENV AMP=$amp
ENV MAX_TO_KEEP=$max_to_keep

ARG english_compatible=0
ENV ENGLISH_COMPATIBLE=$english_compatible

# Copy now so that docker build can leverage caches
COPY italian_alphabet.txt checks.sh generate_alphabet.sh package.sh run.sh counter.py $HOMEDIR/

COPY ${MODEL_LANGUAGE}/*.sh $HOMEDIR/${MODEL_LANGUAGE}/

COPY ${MODEL_LANGUAGE}/lingua_libre_skiplist.txt $HOMEDIR/${MODEL_LANGUAGE}/

ENTRYPOINT "$HOMEDIR/run.sh"