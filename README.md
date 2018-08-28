# Rialto Webapp

This is the Blacklight frontend for Rialto.


## Dependencies

1. A database (RDS)
1. A Solr index

## Build

```
docker build -t suldlss/rialto-webapp:latest .
```

## Run

```
docker run -p 3000:3000 \
-e SOLR_URL=http://50.16.181.132:8983/solr/rialto-dev \
-e HONEYBADGER_API_KEY=<key> \
suldlss/rialto-webapp:latest
```

## Deploy
```
docker push suldlss/rialto-webapp:latest
```

## Run tests

Frontend:
```
npm test
```

Backend:
```
rake spec
```
