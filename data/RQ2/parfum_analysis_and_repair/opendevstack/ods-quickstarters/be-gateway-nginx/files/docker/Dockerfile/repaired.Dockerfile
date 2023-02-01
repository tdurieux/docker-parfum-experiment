# https://github.com/openresty/docker-openresty
FROM openresty/openresty:1.19.3.2-fedora-rpm

ENV LANG=C.UTF-8

# Example: adding Lua lib dependency for OpenIDConnect:
# 1) with OPM
# RUN opm install zmartzone/lua-resty-openidc
# 2) or with LuaRocks
# RUN luarocks install zmartzone/lua-resty-openidc