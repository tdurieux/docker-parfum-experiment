FROM python:3.6 as base_image

RUN pip install tensorflow
RUN pip install markdown mkdocs pytest sphinx black==19.10b0

FROM python:3.7 as base_image_37

RUN pip install tensorflow
RUN pip install markdown mkdocs pytest sphinx black==19.10b0

FROM base_image as integration_tests
RUN pip install keras==2.3.0
RUN pip install git+https://github.com/keras-team/keras-tuner.git@1.0rc0
COPY ./ ./keras-autodoc
RUN pip install -e ./keras-autodoc
WORKDIR keras-autodoc
RUN pytest tests/test_integration.py

FROM base_image as unit_tests
COPY ./ ./keras-autodoc
RUN pip install -e ./keras-autodoc
WORKDIR keras-autodoc
RUN pytest --ignore=tests/test_integration.py tests/

FROM base_image_37 as unit_tests_py37
COPY ./ ./keras-autodoc
RUN pip install -e ./keras-autodoc
WORKDIR keras-autodoc
RUN pytest --ignore=tests/test_integration.py tests/

FROM base_image_37 as flake8_tests
RUN pip install flake8
COPY ./ ./keras-autodoc
WORKDIR keras-autodoc
RUN flake8

FROM base_image as doc_tests
COPY ./ ./keras-autodoc
RUN pip install -e keras-autodoc
WORKDIR keras-autodoc/docs
RUN python autogen.py
RUN mkdocs build

FROM base_image as test_release
COPY ./ ./keras-autodoc
RUN pip install ./keras-autodoc
