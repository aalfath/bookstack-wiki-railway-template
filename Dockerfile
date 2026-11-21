# BookStack for Railway: LinuxServer.io's BookStack image (the image BookStack's
# install docs point to), pinned by version and digest. Bump both together.
FROM lscr.io/linuxserver/bookstack:v26.09.3-ls300@sha256:5e44313f320a8a6f92f171b1beca4748f3e0a5110a4f4c19047cb4b4e43695a2

# Runs after the image's own init (folders, .env, first migration) and before
# nginx and PHP start: waits for the database, migrates, and replaces the
# default admin@admin.com / password login with the deployer's details.
COPY railway-init.sh /custom-cont-init.d/50-railway-init
RUN chmod 755 /custom-cont-init.d/50-railway-init

# nginx listens on 80; Railway routes and health-checks PORT=80.
EXPOSE 80
# The base image's s6-overlay /init stays the entrypoint.
