FROM python:3.9-slim-buster
RUN apt-get update && apt-get install --no-install-recommends -y \
  libdbus-1-3 \
  libfontconfig \
  libgl1-mesa-glx \
  libglib2.0-0 \
  libxcb-icccm4 \
  libxcb-image0 \
  libxkbcommon-x11-0 && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean
WORKDIR /rmview
COPY resources.qrc setup.cfg setup.py ./
COPY assets ./assets
COPY bin ./bin
COPY src ./src
RUN pip install --no-cache-dir --upgrade pip
# TODO: setup.py could to be fixed to include install_requires
#       see also: https://stackoverflow.com/q/21915469/543875
RUN pip install --no-cache-dir pyqt5==5.14.2 paramiko twisted
RUN pip install --no-cache-dir .[tunnel]
RUN pip cache purge
CMD rmview
