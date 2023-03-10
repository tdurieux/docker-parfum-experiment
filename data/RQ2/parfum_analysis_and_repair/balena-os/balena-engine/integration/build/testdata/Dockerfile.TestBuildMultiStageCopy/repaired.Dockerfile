FROM busybox AS base
RUN mkdir existingdir

FROM base AS source
RUN echo "Hello World" > /hello

FROM base AS copy_to_root
COPY --from=source /hello /hello

FROM base AS copy_to_newdir
COPY --from=source /hello /newdir/hello

FROM base AS copy_to_newdir_nested
COPY --from=source /hello /newdir/newsubdir/hello

FROM base AS copy_to_existingdir
COPY --from=source /hello /existingdir/hello

FROM base AS copy_to_newsubdir
COPY --from=source /hello /existingdir/newsubdir/hello