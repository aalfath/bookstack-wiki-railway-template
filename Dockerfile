# BookStack for Railway: LinuxServer.io's BookStack image (the image BookStack's
# install docs point to), pinned by version and digest. Bump both together.
FROM lscr.io/linuxserver/bookstack:v26.09.3-ls297@sha256:42d8c8a5b74e2fd8613547ce14a1c011293765ceb3cd50ef4e751597b457798b

# Runs after the image's own init (folders, .env, first migration) and before
# nginx and PHP start: waits for the database, migrates, and replaces the
# default admin@admin.com / password login with the deployer's details.
COPY railway-init.sh /custom-cont-init.d/50-railway-init
RUN chmod 755 /custom-cont-init.d/50-railway-init

# nginx listens on 80; Railway routes and health-checks PORT=80.
EXPOSE 80
# The base image's s6-overlay /init stays the entrypoint.
