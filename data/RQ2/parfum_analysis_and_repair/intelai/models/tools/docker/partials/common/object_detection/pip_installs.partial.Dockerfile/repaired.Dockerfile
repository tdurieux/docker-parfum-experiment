# Note pycocotools has to be install after the other requirements
RUN pip install --no-cache-dir \
        Cython \
        contextlib2 \
        jupyter \
        lxml \
        matplotlib \
        numpy >=1.17.4 \
        'pillow>=8.1.2' && \
    pip install --no-cache-dir pycocotools
