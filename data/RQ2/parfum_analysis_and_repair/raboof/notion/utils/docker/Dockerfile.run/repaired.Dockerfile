FROM notion

ENV DISPLAY=${NOTION_TEST_DISPLAY:-:1.0}
RUN make install
ENTRYPOINT ["/usr/local/bin/notion"]