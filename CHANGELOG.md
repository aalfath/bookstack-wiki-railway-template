# Changelog

## 26.09.3-ls298 (2026-11-17)

- No breaking changes. BookStack itself stays at v26.09.3; this is LinuxServer.io's image rebuild `v26.09.3-ls298` with updated base packages. Pages, uploads and settings in MySQL and on the `/config` volume are kept.
- Image: `lscr.io/linuxserver/bookstack:v26.09.3-ls298@sha256:7a80c1685f59c264f791b14e836380b982f058438447031ec2136d867eb72a79`.

## Unreleased (2026-11-16)

- README: add the Deploy on Railway button for the published template `bookstack-2`. No change to the app or its image.

## 26.09.3 (2026-11-16)

- First release: BookStack v26.09.3 (LinuxServer.io image `v26.09.3-ls297`, pinned by digest) with Railway's MySQL, a `/config` volume and a `/status` health check.
- First boot replaces the default `admin@admin.com` / `password` login with the deployer's email and a generated password.
