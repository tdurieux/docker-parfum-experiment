FROM seldonio/pyseldon:%SELDON_PYTHON_PACKAGE_VERSION%

ENV SELDON_HOME=/home/seldon
COPY xgb_pipeline.py $SELDON_HOME/xgb_pipeline.py
COPY create-json.py $SELDON_HOME/create-json.py

RUN mkdir -p $SELDON_HOME/data && cd $SELDON_HOME/data ; wget --quiet https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data

RUN mkdir -p $SELDON_HOME/data/iris/events/1 && cat $SELDON_HOME/data/iris.data | python $SELDON_HOME/create-json.py | shuf > $SELDON_HOME/data/iris/events/1/iris.json

RUN cd $SELDON_HOME && python $SELDON_HOME/xgb_pipeline.py --events data/iris/events/1 --models /data/iris/xgb_models/1

RUN mkdir $SELDON_HOME/proto
RUN mkdir $SELDON_HOME/python

COPY proto/iris.proto $SELDON_HOME/proto/iris.proto

RUN python -m grpc.tools.protoc -I $SELDON_HOME/proto  --python_out=$SELDON_HOME/python --grpc_python_out=$SELDON_HOME/python $SELDON_HOME/proto/iris.proto

COPY python/iris_rpc_microservice.py $SELDON_HOME/python

COPY run_microservice.sh /run_microservice.sh

CMD ["/run_microservice.sh"]

