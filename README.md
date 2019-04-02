# Rialto Webapp
[![](https://images.microbadger.com/badges/image/suldlss/rialto-webapp.svg)](https://microbadger.com/images/suldlss/rialto-webapp "Get your own image badge on microbadger.com")

This is the Blacklight frontend for Rialto.


## Dependencies

1. A database (RDS)
1. A Solr index
1. `config/master.key` containing the master key added to your clone of this repository.

## Build Docker image

```
./bin/build
```

## Run

```
docker run -p 3000:3000 \
-e SOLR_URL=http://50.16.181.132:8983/solr/rialto-dev \
-e HONEYBADGER_API_KEY=<key> \
-e RAILS_MASTER_KEY=<key> \
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

To bring up a test database in a Docker container:
```
docker run --rm --name rialto_test_db -e POSTGRES_DB=rialto_test -p 5432:5432 -e POSTGRES_USER=$USER -d postgres:9.6.2-alpine
```

To bring up a test Solr in a Docker container:
```
docker run -d -p 8983:8983 -v $PWD/solr/conf:/myconfig solr:7 solr-create -c blacklight-core -d /myconfig
```
