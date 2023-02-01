FROM stimela/base:1.4.6
MAINTAINER <sphemakh@gmail.com>
RUN pip install --no-cache-dir msutils
RUN python -c "import MSUtils.msutils"
