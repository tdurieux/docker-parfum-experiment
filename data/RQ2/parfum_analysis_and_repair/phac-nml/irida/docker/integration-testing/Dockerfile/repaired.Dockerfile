# Galaxy - IRIDA Integration Testing Image

FROM phacnml/galaxy-irida-20.09:base 

# Add test tool configs
ADD ./galaxy/tool_conf_irida.xml /galaxy-central/config/tool_conf.xml

# Set up proper admin users
RUN sed -i -e 's/^\(.*\)#admin_users: .*/\1admin_users: admin@galaxy.org,workflowUser@irida.corefacility.ca/' /etc/galaxy/galaxy.yml

# Add custom Irida tools to Galaxy