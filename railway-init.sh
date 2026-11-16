#!/usr/bin/with-contenv bash
# shellcheck shell=bash
# Railway first-boot hook for BookStack. Safe to run on every boot.
set -u
cd /app/www || exit 1

as_abc() { s6-setuidgid abc "$@"; }
# A failed custom init does not stop LinuxServer containers, so halt here (as the
# image does for a missing APP_KEY): the health check then fails and Railway
# never routes traffic to an app with the default admin password.
halt() { echo "[railway-init] $*"; echo "[railway-init] halting startup"; sleep infinity; }

# 1. The image waits only 30 s for the database. Retry the migration until the
#    database answers (up to ~5 minutes), so a slow first MySQL boot is fine.
ok=0
for i in $(seq 1 60); do
  if as_abc php artisan migrate --force >/tmp/railway-migrate.log 2>&1; then
    ok=1; break
  fi
  echo "[railway-init] database not ready yet (attempt $i), retrying in 5 s"
  sleep 5
done
if [ "$ok" != 1 ]; then
  cat /tmp/railway-migrate.log
  halt "migration failed"
fi
echo "[railway-init] database schema is up to date"

# 2. Replace the default admin login (admin@admin.com / password).
#    --initial only updates the default admin while it still exists; once it's
#    gone it exits 2 ("non-default admin exists") and changes nothing.
email="${BOOKSTACK_ADMIN_EMAIL:-}"
pass="${BOOKSTACK_ADMIN_PASSWORD:-}"
name="${BOOKSTACK_ADMIN_NAME:-Admin}"
if [ -z "$email" ] || [ -z "$pass" ]; then
  halt "BOOKSTACK_ADMIN_EMAIL and BOOKSTACK_ADMIN_PASSWORD must be set; refusing to start with the default admin password"
fi
as_abc php artisan bookstack:create-admin --initial \
  --email="$email" --name="$name" --password="$pass"
rc=$?
case "$rc" in
  0) echo "[railway-init] admin account set to $email" ;;
  2) echo "[railway-init] admin already set up, nothing to change" ;;
  *) halt "could not set the admin account (exit $rc)" ;;
esac
