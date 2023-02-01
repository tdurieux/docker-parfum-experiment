FROM python:3.6
USER root

WORKDIR /app
RUN apt-get update && apt -y --no-install-recommends install g++ cmake && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir xgboost pandas numpy joblib sklearn

COPY job/xgb_train_and_predict/* /app/
COPY job/pkgs /app/job/pkgs
ENV PYTHONPATH=/app:$PYTHONPATH

ENTRYPOINT ["python3", "launcher.py"]
