FROM ubuntu

ENV message <%= message %>

<% if (env.somevar) { %>
ENV env_somevar <%= env.somevar %> 
<% } %>

ADD ./greeting.txt /greeting.txt 

CMD ["bash"]