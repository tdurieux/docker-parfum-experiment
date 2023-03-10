FROM ubuntu:16.04


RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        software-properties-common && \
    add-apt-repository -y ppa:thopiekar/pyside-git && \
    apt-get update && apt-get install --no-install-recommends -y \
        python \
        python-dev \
        python-pip \
        python-qt4 \
        python-pyqt5 \
        python-pyside \
        python-pyside2 \
        xvfb && rm -rf /var/lib/apt/lists/*;

# Nose is the Python test-runner
# RUN pip install -r /QtPyConvert/requirements.txt

# Enable additional output from Qt.py
ENV QT_VERBOSE true

# Xvfb
ENV DISPLAY :99
ENV PYTHONPATH="${PYTHONPATH}:/workspace/QtPyConvert/src/python"

WORKDIR /workspace/QtPyConvert/src/python
ENTRYPOINT cp -r /QtPyConvert /workspace && \
        Xvfb :99 -screen 0 1024x768x16 2>/dev/null & \
        sleep 3 && \
    pip install -r /workspace/QtPyConvert/requirements.txt && \
    python /workspace/QtPyConvert/tests/test_core/test_binding_supported.py && \
    python /workspace/QtPyConvert/tests/test_core/test_replacements.py && \
    python /workspace/QtPyConvert/tests/test_psep0101/test_qsignal.py && \
    python /workspace/QtPyConvert/tests/test_psep0101/test_qvariant.py && \
    python /workspace/QtPyConvert/tests/test_qtcompat/test_compatibility_members.py
