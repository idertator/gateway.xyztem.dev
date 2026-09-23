NETWORK := xyztem

.PHONY: network network-rm

network:
	@docker network inspect $(NETWORK) >/dev/null 2>&1 || docker network create $(NETWORK)

# Fails loudly if the network exists but cannot be removed (e.g. containers still attached).
network-rm:
	@if docker network inspect $(NETWORK) >/dev/null 2>&1; then \
		docker network rm $(NETWORK); \
	else \
		echo "network $(NETWORK) does not exist"; \
	fi
