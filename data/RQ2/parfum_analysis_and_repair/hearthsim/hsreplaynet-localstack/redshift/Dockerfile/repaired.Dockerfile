FROM hearthsim/pgredshift:latest

RUN apt-get update && apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*;

RUN curl -O https://libs.hearthsim.net/hsredshift-0.1.0.tar.gz --fail && \
	mkdir /tmp/hsredshift && tar -xzf hsredshift-0.1.0.tar.gz -C /tmp/hsredshift --strip 1 && rm hsredshift-0.1.0.tar.gz

RUN apt-get install -y --no-install-recommends build-essential python3-dev libpq-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp/hsredshift
RUN /usr/bin/python3.7 -m pip install .

RUN curl -f -O https://libs.hearthsim.net/hsredshift_udfs-0.1.0.tar.gz && \
	mkdir /tmp/hsredshift/udfs && tar -xzf hsredshift_udfs-0.1.0.tar.gz -C /tmp/hsredshift/udfs --strip 1 && rm hsredshift_udfs-0.1.0.tar.gz

WORKDIR /tmp/hsredshift/udfs
RUN /usr/bin/python3.7 -m pip install hearthstone sqlalchemy

RUN \
	/usr/bin/python3.7 ./setup.py bdist_wheel && \
	pip2 install --no-cache-dir --ignore-installed ./dist/*.whl

COPY 10_hsredshift.sh "/docker-entrypoint-initdb.d/"
