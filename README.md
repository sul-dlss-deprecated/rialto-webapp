# Rialto Webapp

This is the Blacklight frontend for Rialto.


## Dependencies

1. A database (RDS)
1. A Solr index


## Deployment

```
docker build -t suldlss/rialto-webapp:latest .
```

## Run

```
docker run -p 3000:3000 suldlss/rialto-webapp:latest -e SOLR_URL=http://50.16.181.132/solr/rialto-dev
```
