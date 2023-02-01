# Docker file for headless tester.  DO NOT PUBLISH IMAGE
#

FROM labtainers/labtainer.master.headless

LABEL description="This is Docker image for the Labtainers master controller tester"
USER root
RUN apt-get install --no-install-recommends -y xdotool net-tools && rm -rf /var/lib/apt/lists/*;
USER labtainer
COPY --chown=labtainer:labtainer labtainer-tests.tar /home/labtainer
RUN cd labtainer && tar xf ../labtainer-tests.tar && rm ../labtainer-tests.tar
#RUN rm labtainer-tests.tar
