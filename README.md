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

## Deploy

### Push updated image

The RIALTO web app is deployed as a container to AWS, and this process is managed by Terraform. The first step of the deployment process is to build, push, and tag an updated image. You can do this manually by following the `Build Docker image` section above and then manually pushing the updated image to Docker Hub:

```
docker push suldlss/rialto-webapp:latest
```

In practice, though, merging any commits into the `master` branch -- e.g., regular dependency updates -- will trigger a CI build which automates building, pushing, and tagging a new image. You can check the [Docker Hub UI](https://hub.docker.com/r/suldlss/rialto-webapp) to see when the image was last updated.

### Update container definitions in Terraform

Once the new image has been successfully pushed, the container definitions for the RIALTO web app in Terraform must be updated. Create a pull request in the [terraform-aws](https://github.com/sul-dlss/terraform-aws) repo that bumps the value of the `DEPLOYED` environment variable for RIALTO web app in both `staging` and `production` environments. Our practice is to bump the date portion of the value, which specifies when changes last flowed into `master`;  the value must change for the new container to be pulled into the RIALTO web app. See this [pull request](https://github.com/sul-dlss/terraform-aws/pull/471/files) as an example.

Note that a member of the **Operations team** must approve and merge this PR, but the PR does not need to be merged before beginning the next section.

### Deploy to staging environment

Once the Terraform PR in the prior section has been merged -- or run this from your branch, no need to wait on `master`! -- use Terraform to deploy the RIALTO web app to the staging environment. Note that you will need a [Vault](https://www.vaultproject.io/) account to proceed. Create an [operations tasks](https://github.com/sul-dlss/operations-tasks/) issue to request one if you do not have one already.

1. Install [Vault](https://www.vaultproject.io/) via your favorite OS package management system. We use Vault to manage secrets and control access to our Terraform infrastructure.
1. Specify our Vault root URL in an environment variable: `export VAULT_ADDR=https://vault.sul.stanford.edu/`
1. Get a Vault token: `vault login -method=userpass username=USERNAME password=PASSWORD`
1. Change into the RIALTO staging terraform directory: `cd {terraform-aws-root-directory}/organizations/staging/rialto`
1. Ensure you have environment variables set for `AWS_SECRET_ACCESS_KEY` and `AWS_ACCESS_KEY_ID` so that you can be authenticated to AWS.
1. Initialize terraform if you have not run this yet: `terraform init`
1. Run `terraform plan`
    * If you are prompted for `var.profile`, enter the name of AWS staging profile
    * Verify that the only changes highlighted by `terraform plan` are related to the updated web app container: `Plan: 1 to add, 1 to change, 1 to destroy.`
1. Run `terraform apply`
1. Ensure you have set up the AWS console with the appropriate roles: https://github.com/sul-dlss/terraform-aws/wiki/AWS-DLSS-Dev-Env-Setup
1. Watch [the RIALTO web app deployment in the AWS console](https://us-west-2.console.aws.amazon.com/ecs/home?region=us-west-2#/clusters/rialto-staging/services/rialto/deployments), using `DevelopersRole` in the `sul-dlss-staging` account. You should see two deployments for some time (15-20 minutes). Eventually, the newer deployment will be the only one running. That means the container has now been updated in the staging environment.
1. In your browser, hit [the RIALTO web app staging URL](https://rialto.stage.sul.stanford.edu). If it resolves and renders, you can move on to the next section.

### Deploy to production environment

Once you have verified all went well in staging, request that the Operations team run deploy the RIALTO web app to production by creating an [operations tasks](https://github.com/sul-dlss/operations-tasks/) issue. Once this has been done, verify that the production RIALTO web app URL https://rialto.sul.stanford.edu/ resolves and renders.
