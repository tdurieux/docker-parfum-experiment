FROM faber-alice-demo

# Install bdd dependencies
RUN pip3 install --no-cache-dir -r demo/requirements.behave.txt

WORKDIR ./demo
RUN chmod a+w .
ENTRYPOINT ["behave"]