FROM ubuntu

<% if env.http_proxy) { %>
ENV http_proxy <%= http_proxy %>
<% } %>

CMD ["echo", "hello"]