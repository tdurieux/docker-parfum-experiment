# Are you bumping postgres minor or major version?
# Please review the changes in /usr/local/share/postgresql/postgresql.conf.sample
# If there is any change, you should ping @team/delivery
# And Delivery will make sure changes are reflected in our deploy repository
FROM postgres:12.7-alpine@sha256:b815f145ef6311e24e4bc4d165dad61b2d8e4587c96cea2944297419c5c93054

ARG PING_UID=99
ARG POSTGRES_UID=999

# We modify the postgres user/group to reconcile with our previous debian based images
# and avoid issues with customers migrating.