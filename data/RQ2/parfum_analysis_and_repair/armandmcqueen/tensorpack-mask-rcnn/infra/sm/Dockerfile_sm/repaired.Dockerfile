FROM fewu/sagemaker-mask-rcnn:lateset

# Copies the training code inside the container
COPY run_mpi.py /opt/ml/code/run_mpi.py
COPY run.sh /opt/ml/code/run.sh

# Defines train.py as script entry point
ENV SAGEMAKER_PROGRAM run_mpi.py