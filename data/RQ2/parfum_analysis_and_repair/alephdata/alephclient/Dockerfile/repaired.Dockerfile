FROM alephdata/followthemoney
RUN pip3 install --no-cache-dir alephclient
CMD alephclient
