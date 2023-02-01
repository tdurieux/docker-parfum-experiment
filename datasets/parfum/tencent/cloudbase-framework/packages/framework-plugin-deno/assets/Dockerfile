FROM <%= dockerImage %>

WORKDIR /install

RUN apt-get update && apt-get install curl unzip -y
RUN curl -fsSL https://x.deno.js.cn/install.sh | sh <%= denoVersion %>

ENV DENO_DIR="/root/.cache/deno"
ENV DENO_INSTALL="/root/.deno"
ENV PATH="$DENO_INSTALL/bin:$PATH"
ENV PORT=80
EXPOSE 80

WORKDIR /app
COPY . .
RUN deno install --allow-read --allow-run --allow-write --allow-net -f -q --unstable https://deno.land/x/denon<%= denonVersion %>/denon.ts
<% if (autoBuild) { %>
RUN denon build
<% } %>
<% if (entry) { %>
RUN deno install <%= entry %>
<% } %>

CMD denon start
