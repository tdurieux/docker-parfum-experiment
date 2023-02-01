FROM nvidia/cuda:11.2.1-base
COPY cache/recent_change_rtd_hyper_dataset /app/cache/recent_change_rtd_hyper_dataset

#set up environment
RUN apt-get update -y && apt-get install --no-install-recommends -y gcc && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3.8 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
# RUN apt-get install nvidia-container-runtime
# RUN pip3 install cython
# RUN pip3 install setuptools
# RUN pip3 install sklearn

COPY ml_models/hyperparametertuning_requirements.txt /app/hyperparametertuning_requirements.txt
RUN pip3 install --no-cache-dir -r /app/hyperparametertuning_requirements.txt
#copies the applicaiton from local path to container path
COPY cache/recent_change_rtd_ar_cs_encoder_dict.pkl /app/cache/recent_change_rtd_ar_cs_encoder_dict.pkl
COPY cache/recent_change_rtd_dp_cs_encoder_dict.pkl /app/cache/recent_change_rtd_dp_cs_encoder_dict.pkl
COPY ml_models /app/ml_models
COPY helpers /app/helpers
COPY database /app/database
WORKDIR /app
CMD ["python3", "ml_models/hyperparametertuning_xgboost.py"]