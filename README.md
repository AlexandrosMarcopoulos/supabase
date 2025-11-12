## Supabase Liquibase Deployments

This repo manages the BrightSkills Supabase database via Liquibase. Runbooks now rely on GitHub Actions so migrations can execute from an environment that always has network access to port 5432.

### Repo layout

- `db/changelog/master.changelog.yaml` — master changelog that includes every SQL change in `db/changelog/changes/`.
- `db/changelog/changes/0001_init.sql` — Liquibase-formatted SQL that creates the `public.skills` table.
- `db/liquibase.properties` — shared defaults (changelog path, driver, classpath).
- `db/lib/postgresql.jar` — PostgreSQL JDBC driver mounted into CI.
- `.github/workflows/liquibase-update.yml` — workflow that runs Liquibase inside the official Docker image.

### Required GitHub secrets / vars

Add the following at the repository (or organization) level before triggering the workflow:

| name | type | description |
| --- | --- | --- |
| `SUPABASE_JDBC_URL` | secret | Full JDBC URL from Supabase (e.g. `jdbc:postgresql://.../postgres?sslmode=require`). |
| `SUPABASE_DB_USER` | secret | Database username, usually `postgres`. |
| `SUPABASE_DB_PASS` | secret | Database password. |
| `LIQUIBASE_LOG_LEVEL` | variable (optional) | Log level to pass to Liquibase (defaults to `info` when unset). |

### Triggering a deploy

1. Push a change under `db/**` to the `main` branch **or** use the **Run workflow** button on the *Liquibase Migrations* workflow to run manually.
2. The job:
   - Checks out the repo.
   - Verifies that the three required secrets exist.
   - Runs `docker run liquibase/liquibase:4.33 ... update`, mounting the repo so `db/liquibase.properties` and the PostgreSQL driver are available.
3. Liquibase connects to Supabase using the provided secrets and applies any pending changesets.

### Local development

You can still run Liquibase locally with the same files:

```bash
cd /Users/brightskills/supabase
export LB_URL="jdbc:postgresql://<host>:5432/postgres?sslmode=require"
export LB_USER="postgres"
export LB_PASS="••••"
liquibase --defaultsFile=db/liquibase.properties \
  --url="$LB_URL" --username="$LB_USER" --password="$LB_PASS" update
```

Whenever local networking is blocked, rely on the GitHub Action above to deploy.
