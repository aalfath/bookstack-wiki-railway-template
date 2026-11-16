# BookStack on Railway

A one-click Railway template for [BookStack](https://www.bookstackapp.com/), the open-source wiki and documentation platform that organises content into shelves, books, chapters and pages.

## What it deploys

| Service | Source | Notes |
|---|---|---|
| **BookStack** | this repo (`Dockerfile`) | BookStack **v26.09.3** on LinuxServer.io's image `lscr.io/linuxserver/bookstack:v26.09.3-ls297`, pinned by digest. Public HTTPS domain, health check `/status`, volume on `/config` (uploads, images, attachments, logs). |
| **MySQL** | Railway's MySQL | Private only, with its own volume. |

BookStack doesn't publish its own Docker image; its [installation docs](https://www.bookstackapp.com/docs/admin/installation/#docker) point to the LinuxServer.io and solidnerd community images. This template uses LinuxServer.io's.

## Variables

| Variable | Default | Purpose |
|---|---|---|
| `BOOKSTACK_ADMIN_EMAIL` | *(you enter it)* | Email you log in with as the first admin. |
| `BOOKSTACK_ADMIN_PASSWORD` | generated | First admin's password. Read it in the BookStack service's **Variables** tab. |
| `APP_KEY` | generated | Laravel encryption key. Don't change it after the first deploy. |
| `APP_URL` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` | Public URL. Change it if you add a custom domain. |
| `DB_*` | references to MySQL | Database connection. |
| `PORT` | `80` | Port nginx listens on. |

On every boot, `railway-init.sh` waits for the database, runs migrations and, the first time, replaces BookStack's default `admin@admin.com` / `password` account with your email and the generated password. After that it changes nothing, so change your password in BookStack itself (changing the variable later has no effect). If the admin can't be set, the container stops before nginx starts, so the app is never reachable with the default password.

Optional settings (email via `MAIL_*`, LDAP, SAML, OIDC) are plain environment variables; see BookStack's [docs](https://www.bookstackapp.com/docs/admin/). Add them to the BookStack service.

## Updates

This template builds from this repository, so Railway shows an "update available" notice to everyone who deployed it when a change lands on `main`. Each update bumps the pinned image and is described in [CHANGELOG.md](CHANGELOG.md); read it before applying. Back up the MySQL volume before major upgrades. BookStack runs its database migrations on start.

## Running it elsewhere

```sh
docker build -t bookstack-railway .
```

Set the variables above (with `DB_HOST`, `DB_PORT`, `DB_USERNAME`, `DB_PASSWORD`, `DB_DATABASE` for your MySQL 8+ or MariaDB 10.6+) and mount a volume on `/config`.
