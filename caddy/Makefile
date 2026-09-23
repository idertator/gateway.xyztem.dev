up:
	docker compose up -d --force-recreate

down:
	docker compose down

caddy-reload:
	docker exec -w /etc/caddy caddy sh -c 'caddy fmt --overwrite && caddy reload'

caddy-rebuild:
	docker compose build caddy
	docker compose up -d --no-deps --force-recreate caddy
