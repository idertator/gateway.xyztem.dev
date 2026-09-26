# gateway.xyztem.dev

This give access to the following home sites through a Tailscale private network:

- downloads.xyztem.dev
- sure.xyztem.dev

## Ports Mappings

### home1.xyztem.dev (Private)

- 3000 -> sure.idertator.com 
- 8080 -> downloads.idertator.com 

### home2.xyztem.dev (Public)

- 8000 -> backend.t3s.es
- 8080 -> admin.t3s.es
- 8081 -> agencies.t3s.es
- 8082 -> b2c.t3s.es
- 8083 -> partners.t3s.es
- 8084 -> hoteliers.t3s.es
- 8085 -> helpdesk.t3s.es
- 8100 -> payments.t3s.es, pay.t3s.es (b2c)
- 8101 -> unsubscribe.t3s.es
- 8102 -> v.t3s.es
- 8103 -> contacts.t3s.es
- 8104 -> [www.]t3s.es

- 8500 -> dev.alextheplumber.net, devm.alextheplumber.net

### home3.xyztem.dev (Services)

- 60284 -> minio.t3s.es 
- 16285 -> files.t3s.es
- 56734 -> meili.t3s.es
