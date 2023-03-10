FROM mottosso/maya:2016sp1

RUN wget https://bootstrap.pypa.io/pip/2.7/get-pip.py && \
	mayapy get-pip.py && \
	mayapy -m pip install \
		nose \
		nose-exclude \
		coverage \
		pyblish-base \
		pyblish-maya \
		pymongo \
		sphinx \
		six \
		sphinxcontrib-napoleon

# Avoid creation of auxiliary files
ENV PYTHONDONTWRITEBYTECODE=1

WORKDIR /workspace

ENTRYPOINT \
	PYTHONPATH=$(pwd):$PYTHONPATH && \
	mayapy -u run_maya_tests.py