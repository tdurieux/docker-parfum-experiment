FROM node:16-alpine

ARG USER=vindi
ARG GROUP=vindi
ARG version

# handles user & group creation and assignment
RUN addgroup -S $USER \
	&& adduser -S $USER -G $GROUP \
	&& addgroup $USER root

WORKDIR /vindigo
VOLUME [ "/vindigo/data" ]
COPY ./scripts/entrypoint.sh /vindigo/entrypoint.sh

# in the near future come up with a definitive fix.
# mkdir -p is a work around which fixes a weird behaviour within
# the user permissions system
RUN yarn global add "@vindigo/cli@$version" \
	&& mkdir -p /vindigo/data \
	&& chown -R $USER:$GROUP /vindigo \
	&& chmod +x /vindigo/entrypoint.sh

USER $USER

ENTRYPOINT [ "sh", "./entrypoint.sh" ]
CMD [ "run" ]