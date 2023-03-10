FROM alpine

RUN apk add --no-cache python3 bash git gcc g++ python3-dev libffi-dev \
	&& pip3 install --no-cache-dir --upgrade pip

RUN \




	git clone https://github.com/twintproject/twint.git \
	#
	# Now remove references to Pandas.
	# This may break some functionality, but it also reduces install time on
	# my 4-core i7 from like 15 minutes to more like 30 seconds, and since
	# my usecases don't currently touch Pandas, that's a win.
	#
	&& sed -i -e "s/'pandas', //" /twint/setup.py \
	&& sed -i -e "s/Pandas_au = True/Pandas_au = False/" /twint/twint/config.py \
	&& sed -i -e "s/import pandas as pd/pd = None/" /twint/twint/storage/panda.py \
    #
    # Allow the user to adjust the timeout with the TWINT_TIMEOUT parameter, as 
    # having 120 seconds by default sometimes causes performance issues, and I'd
    # rather the user make their own decisions about when they should have timeouts.
    #
    && sed -i -e "s/with timeout(120):/\
import os\n\
    my_timeout = int(os.environ.get('TWINT_TIMEOUT', "120"))\n\
    logme.warn(\"Timeout: {} secs\".format(my_timeout))\n\
    with timeout(my_timeout):\n\
	/g"  /twint/twint/get.py \ 
	#
	# Now install Twint.
	# \
	&& pip3 install --no-cache-dir -e /twint


#
# Install SQLAlchemy for running any Python scripts within the container
#
RUN pip3 install --no-cache-dir sqlalchemy

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]


