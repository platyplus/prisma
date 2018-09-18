# Prisma Helm Chart
[![Codefresh build status]( https://g.codefresh.io/api/badges/pipeline/plmercereau/platyplus%2Fprisma%2Fprisma?branch=master&key=eyJhbGciOiJIUzI1NiJ9.NWI5M2U0MGQwNTdiOGUwMDAxZmFkMjgx.OXdTB7Vte67YoKtDo9yes3tLkr8usTBnsY7t8HtTkyg&type=cf-1)]( https://g.codefresh.io/repositories/platyplus/prisma/builds?filter=trigger:build;branch:master;service:5b9c12c6e8852163437abb43~prisma)

https://cloud.google.com/sql/docs/mysql/connect-kubernetes-engine
TODO: username and password in a secret?
TODO document CloudSQL

## Pushing the chart to a codefresh repository
### Get an API token
https://g.codefresh.io/account-conf/tokens

### Edit ~/.cfconfig
```bash
contexts:
  default:
    type: APIKey
    name: default
    url: 'https://g.codefresh.io'
    token: 5b9aba85ce29f40100049dd9.cd2afcfd71331f4d4fe44f07ccc4c8b5
    beta: false
    onPrem: false
current-context: default
```

### Add the repository
Attention: the repo should be public!
-> to create a cf repo: codefresh create helm-repo platyplus
-> then codefresh patch helm-repo platyplus -public
```bash
helm plugin install https://github.com/chartmuseum/helm-push
helm repo add platyplus cm://h.cfcr.io/plmercereau/platyplus
# npm install -g codefresh
```
### Push the chart to the repository
```bash
helm push . platyplus
```

### Make the repository public
```bash
codefresh patch helm-repo platyplus -public 
```
## Configuring the public chart repository (if not configured to push charts)
```bash
helm repo add platyplus https://h.cfcr.io/plmercereau/default
```

## Installing the Chart
### Via a local helm chart
To install the chart with the release name `prisma`:

```bash
git clone https://github.com/platyplus/prisma-chart.git && cd prisma-chart
helm dep up .
export PRISMA_MANAGEMENT_API_SECRET=<secret>
export CLOUDSQL_PASSWORD=<password>
export CLOUDSQL_HOST=<CloudSQL host>
export CLOUDSQL_CREDENTIALS=`cat cloudsql-instance-credentials.json | base64`
helm install --name prisma \
    --set service.secret=$PRISMA_MANAGEMENT_API_SECRET \
    --set database.googleCloudCredentials=$CLOUDSQL_CREDENTIALS \
	--set database.password=$CLOUDSQL_PASSWORD \
    --set database.googleCloudSQL.host=$CLOUDSQL_HOST \
	-f ./values.yaml .
```
### Via a Helm repository
TODO


# TODO: review
By default, this chart includes a PostgreSQL chart as a dependency in the `requirements.yaml` file. However, this can be disabled and Prisma can be configured to use any other supported database.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm del --purge my-release 
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Prisma chart and their default values.

| Parameter                     | Description                                  | Default                                                              |
| ----------------------------- | -------------------------------------------- | -------------------------------------------------------------------- |
| `image`                       | `prisma` image repository                    | `prismagraphql/prisma`                                               |
| `imageTag`                    | `prisma` image tag                           | `1.8`                                                                |
| `imagePullPolicy`             | Image pull policy                            | `IfNotPresent`                                                       |
| `database.connector`          | Database connector                           | `postgres`                                                           |
| `database.user`               | Database user                                | `prisma`                                                             |
| `database.password`           | Database user's password                     | `prisma`                                                             |
| `database.host`               | Host for the database endpoint               | `nil`                                                                |
| `database.port`               | Port for the database endpoint               | `nil`                                                                |
| `auth.enabled`                | Use authentication for `prisma`              | `false`                                                              |
| `auth.secret`                 | Secret to use for authentication             | `nil`                                                                |
| `service.type`                | k8s service type exposing ports              | `ClusterIP`                                                          |
| `service.port`                | TCP port                                     | `4466`                                                               |
| `ingress.enabled`             | Enables Ingress                              | `false`                                                              |
| `ingress.annotations`         | Ingress annotations                          | `{}`                                                                 |
| `ingress.path`                | Ingress path                                 | `/`                                                                  |
| `ingress.hosts`               | Ingress accepted hostnames                   | `[]`                                                                 |
| `ingress.tls`                 | Ingress TLS configuration                    | `[]`                                                                 |
| `resources`                   | CPU/Memory resource requests/limits          | `{}`                                                                 |
| `nodeSelector`                | Node labels for pod assignment               | `{}`                                                                 |
| `affinity`                    | Affinity settings for pod assignment         | `{}`                                                                 |
| `tolerations`                 | Toleration labels for pod assignment         | `[]`                                                                 |
| `postgresql.enabled`          | Install PostgreSQL chart                     | `true`                                                               |
| `postgresql.resources`        | PostgreSQL resource requests and limits      | Memory: `256Mi`, CPU: `100m`                                         |
| `postgresql.imagePullPolicy`  | PostgreSQL image pull policy                 | `Always` if `imageTag` is `latest`, else `IfNotPresent`              |
| `postgresql.postgresUser`     | Username of new user to create               | `prisma`                                                             |
| `postgresql.postgresPassword` | Password for the new user                    | `prisma`                                                             |

Additional configuration parameters for the PostgreSQL database deployed with Prisma can be found [here](https://github.com/kubernetes/charts/tree/master/stable/postgresql).

> **Tip**: You can use the default [values.yaml](values.yaml)
