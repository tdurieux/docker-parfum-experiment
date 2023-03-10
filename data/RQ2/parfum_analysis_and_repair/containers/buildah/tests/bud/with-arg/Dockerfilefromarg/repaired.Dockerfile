ARG app_type
ARG another_app_type
ARG another_app_type_default=m

FROM alpine as x
RUN echo hello

FROM ${app_type} as m
RUN echo world

# Do not supply this in cli, lets use default
FROM ${another_app_type_default} as final
RUN echo hello

FROM ${another_app_type} as final
RUN echo hello