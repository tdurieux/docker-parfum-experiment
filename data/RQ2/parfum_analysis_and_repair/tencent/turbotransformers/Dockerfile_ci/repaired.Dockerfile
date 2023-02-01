FROM thufeifeibear/turbo_transformers_gpu:latest

RUN pip install --no-cache-dir onnxruntime==1.4.0

ADD ./ /workspace/
ENTRYPOINT ["bash", "/workspace/tools/ci_check.sh", "/workspace"]
