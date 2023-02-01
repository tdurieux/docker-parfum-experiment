FROM agilgur5/ltlmop
MAINTAINER agilgur5

# install wxtools minimally
RUN apt-get install -y --no-install-recommends python-wxtools && \
  apt-get autoremove -y && rm -rf /var/lib/apt/lists/*;

# launch spec editor by default
WORKDIR /LTLMoP/src
CMD python specEditor.py
