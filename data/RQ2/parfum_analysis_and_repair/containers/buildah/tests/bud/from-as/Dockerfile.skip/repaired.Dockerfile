FROM alpine AS base
RUN touch /1
ENV LOCAL=/1
RUN find $LOCAL
RUN touch hello

FROM base
RUN find $LOCAL
RUN touch /2
ENV LOCAL2=/2
RUN find $LOCAL2
# so we don't end up skipping stage: 0
COPY --from=0 hello .

FROM base
RUN find $LOCAL
RUN ls /
# so we don't end up skipping stage: 1
COPY --from=1 hello .