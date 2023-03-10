from alpine

RUN mkdir /dir-with-whiteout && touch /dir-with-whiteout/file
RUN rm /dir-with-whiteout/file

# this layer is useful to test that the whiteout is applied in the right order,
# i.e. first the whiteout has to be applied to the parent layers, then
# the file has to be created
RUN mkdir /dir-with-artificial-whiteout \
    && touch /dir-with-artificial-whiteout/.wh.file \
    && touch /dir-with-artificial-whiteout/file

RUN mkdir /dir-with-artificial-opaque-whiteout \
    && touch /dir-with-artificial-opaque-whiteout/file0 \
    && touch /dir-with-artificial-opaque-whiteout/file1
RUN touch /dir-with-artificial-opaque-whiteout/.wh..wh..opq

RUN mkdir /dir-removed-and-recreated-as-file-on-same-layer
RUN rm -r /dir-removed-and-recreated-as-file-on-same-layer \
    && touch /dir-removed-and-recreated-as-file-on-same-layer

RUN touch /file-removed-and-recreated-as-dir-on-same-layer
RUN rm /file-removed-and-recreated-as-dir-on-same-layer \
    && mkdir /file-removed-and-recreated-as-dir-on-same-layer

RUN touch /file-in-root-folder
RUN rm /file-in-root-folder