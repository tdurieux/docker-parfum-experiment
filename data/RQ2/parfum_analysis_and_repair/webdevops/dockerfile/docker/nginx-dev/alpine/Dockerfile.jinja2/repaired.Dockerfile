{{ docker.from("nginx", "alpine") }}

{{ environment.webDevelopment() }}

{{ docker.copy('conf/', '/opt/docker/') }}

{{ docker.expose('80 443') }}