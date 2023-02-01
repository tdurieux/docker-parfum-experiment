#FROM vonx-base
FROM bcgovimages/von-image:py36-1.7-ew-0

WORKDIR $HOME

ADD config $HOME/config
ADD docker $HOME/docker
ADD greenlight-agent/src $HOME/src
ADD greenlight-agent/templates $HOME/templates

USER root

# Add the indy user to the root group.