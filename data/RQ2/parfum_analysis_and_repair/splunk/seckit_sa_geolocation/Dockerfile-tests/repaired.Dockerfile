#Splunk Connect for Syslog (SC4S) by Splunk, Inc.
#
#To the extent possible under law, the person who associated CC0 with
#Splunk Connect for Syslog (SC4S) has waived all copyright and related or neighboring rights
#to Splunk Connect for Syslog (SC4S).
#
#You should have received a copy of the CC0 legalcode along with this
#work.  If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
ARG IMAGE_TAG=3.7-browsers
FROM circleci/python:$IMAGE_TAG
RUN mkdir -p /home/circleci/work/tests;\
    mkdir -p /home/circleci/work/test-results/functional

COPY tests/entrypoint.sh /
COPY .pytest.expect /home/circleci/work/.pytest.expect
COPY requirements_dev.txt /home/circleci/work/
COPY tests /home/circleci/work/tests
# hadolint ignore=DL3003
RUN cd /home/circleci/work/tests && ls && cd ../..

COPY package /home/circleci/work/package
COPY output /home/circleci/work/output

USER root
RUN chown -R circleci /home/circleci/;\
    mkdir -p /opt/splunk/var/log/splunk;\
    chmod -R 777 /opt/splunk/var/log/splunk

USER circleci
# hadolint ignore=DL3025