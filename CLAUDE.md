# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Infrastructure-as-config (no application code) for the `xyztem.dev` edge gateway: a single Caddy
reverse proxy, run via Docker Compose, that terminates TLS for public hostnames and forwards to
home services reachable over a Tailscale private network. Traffic path:

```
client → Cloudflare → Caddy (this repo, ports 80/443) → Tailscale IP (100.x.y.z) of home service
```

## Commands

All commands run from `caddy/`:

```bash
cp .env.example .env            # first-time setup; set CADDY_ADMIN_PASSWORD
docker network create xyztem    # one-time; compose expects this external network
docker compose up -d
docker compose logs -f caddy
docker compose exec caddy caddy validate --config /etc/caddy/Caddyfile   # syntax-check before reload
docker compose restart caddy    # only needed for compose/volume changes
```

Caddy runs with `--watch`, so **edits to any mounted `*.Caddyfile` apply automatically** — no
restart. Adding a *new* site file does require editing `docker-compose.yml` (see below) and
`docker compose up -d`.

## Architecture

- `caddy/etc/caddy/Caddyfile` — global options + shared snippets. Ends with `import "*.Caddyfile"`,
  which pulls in every sibling site file.
- `caddy/etc/caddy/<name>.Caddyfile` — one file per public hostname, each a site block with a
  `reverse_proxy` to a Tailscale IP.
- `caddy/docker-compose.yml` — mounts each site file **individually** as its own bind mount, not the
  directory. This is the key constraint: the glob import only sees files explicitly listed here.

### Adding a site

1. Create `caddy/etc/caddy/<name>.Caddyfile` with the site block and `reverse_proxy <tailscale-ip>:<port>`.
2. Add a matching bind mount line in `docker-compose.yml` under `volumes`.
3. `docker compose up -d` (recreates the container to pick up the new mount).
4. Add `import cache_policy` inside the site block if the upstream serves a web frontend.

### Global config notes

- **`cache_policy` snippet** — classifies build-output paths (`/assets/*`, `/_next/static/*`,
  `/_nuxt/*`, `/static/{js,css,media}/*`) as year-long immutable; everything else gets `no-store`
  at both browser and CDN so deploys land immediately. Uses `defer` so these headers override
  upstream ones. Site blocks must opt in with `import cache_policy`.
- **ACME via ZeroSSL**, not Let's Encrypt (`acme_ca https://acme.zerossl.com/v2/DV90`).
- **`trusted_proxies`** is a hardcoded static list of Cloudflare IP ranges; refresh from
  https://www.cloudflare.com/ips/ when Cloudflare publishes changes, or real client IPs in logs and
  `X-Forwarded-For` go wrong.
- **Port `2019` is published but the `CADDY_ADMIN_USER`/`CADDY_ADMIN_PASSWORD` env vars in
  `docker-compose.yml` are inert** — Caddy does not read those names, and its admin API has no
  auth mechanism at all. Do not bind the admin endpoint to `0.0.0.0`.
- There is **no `.gitignore`** in this repo yet. `caddy/.env` holds a secret and is not currently
  protected from `git add`.

## Known inconsistency

`README.md` lists the served site as `sure.xyztem.dev`, but `sure.Caddyfile` actually serves
`sure.idertator.com`. Confirm which is intended before relying on either.
