FROM public.ecr.aws/lambda/python:3.9

ARG FUNCTION_DIR="/opt/program"
# Lite version
ARG MODEL_URL="https://aws-gcr-solutions-assets.s3.cn-northwest-1.amazonaws.com.cn/ai-solution-kit/license-plate"
ARG MODEL_VERSION="1.2.0"

ADD / ${FUNCTION_DIR}/

RUN pip3 install --no-cache-dir -i https://mirrors.aliyun.com/pypi/simple/ -r ${FUNCTION_DIR}/requirements.txt
RUN pip3 install --no-cache-dir -i https://mirrors.aliyun.com/pypi/simple/ --target ${FUNCTION_DIR} awslambdaric

RUN mkdir -p ${FUNCTION_DIR}/model
RUN yum install -y wget && rm -rf /var/cache/yum
RUN wget -c $MODEL_URL/$MODEL_VERSION/classifier.onnx -O ${FUNCTION_DIR}/model/classifier.onnx
RUN wget -c $MODEL_URL/$MODEL_VERSION/det_standard.onnx -O ${FUNCTION_DIR}/model/det_standard.onnx
RUN wget -c $MODEL_URL/$MODEL_VERSION/keys_v1.txt -O ${FUNCTION_DIR}/model/keys_v1.txt
RUN wget -c $MODEL_URL/$MODEL_VERSION/rec_standard.onnx -O ${FUNCTION_DIR}/model/rec_standard.onnx

WORKDIR ${FUNCTION_DIR}
ENV PYTHONUNBUFFERED=TRUE
ENV PYTHONDONTWRITEBYTECODE=TRUE
ENV PYTHONIOENCODING="utf8"
ENV MODEL_NAME="standard"
ENV MODEL_PATH="${FUNCTION_DIR}/model/"

ENTRYPOINT [ "python3", "-m", "awslambdaric" ]
CMD [ "license_plate_app.handler" ]