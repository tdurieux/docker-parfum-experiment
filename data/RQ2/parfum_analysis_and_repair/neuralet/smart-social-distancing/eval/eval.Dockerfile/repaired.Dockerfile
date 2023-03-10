# docker can be installed by following instructions:
# build: docker build -f Dockerfile-amd64usbtpu-eval -t neuralet/tools:detector-eval .
# run: docker run -it -v /PATH_TO_CLONED_REPO_ROOT/:/repo neuralet/tools:detector-eval

FROM python:3.6

WORKDIR /repo/applications/smart-distancing/eval

VOLUME /repo

RUN pip install --no-cache-dir --upgrade pip setuptools==41.0.0 && pip install --no-cache-dir six==1.14.0

RUN pip install --no-cache-dir --upgrade pip setuptools==41.0.0 && pip install --no-cache-dir opencv-python==4.2.0.32 && pip install --no-cache-dir six==1.14.0

RUN pip install --no-cache-dir matplotlib==3.1.3

ENTRYPOINT ["python", "pascal_evaluator.py"]

# -gt: folder that contains the ground truth bounding boxes files (Must be located at /eval directory)
# -det: folder that contains your detected bounding boxes files (Must be located at /eval directory)
# -t: IOU thershold that tells if a detection is TP or FP

CMD ["-gt", "eval_files/groundtruths/", "-det", "eval_files/detresults/", "-t", "0.5"]