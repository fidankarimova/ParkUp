# Contributing

## Branching strategy (Git flow)

| Branch | Purpose |
|---|---|
| `main` | Production-ready code. Only `release/*` and `hotfix/*` are merged here. |
| `develop` | Integration branch. All features are merged here. |
| `feature/<short-name>` | New functionality. Branched from `develop`, merged back into `develop` via PR. |
| `release/<version>` | Release preparation. Branched from `develop`, merged into both `main` and `develop`. |
| `hotfix/<short-name>` | Urgent production fix. Branched from `main`, merged into both `main` and `develop`. |

Examples: `feature/parking-geo-search`, `hotfix/booking-double-reserve`

Never push directly to `main` or `develop` — use Pull Requests only.

## Commit messages (Conventional Commits)

```
<type>(<scope>): <short description>

[optional body]

[optional footer: BREAKING CHANGE: ..., Closes #123]
```

**type:** `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`

**scope** (optional): service or area name — `gateway`, `user`, `parking`, `booking`, `payment`, `notification`, `infra`, `docs`

Examples:
```
feat(parking): add nearby parking search with PostGIS
fix(booking): prevent double reservation of same slot
chore(infra): add Kafka UI to docker-compose
feat(user)!: change JWT claims format
```

### Commit message check

The repo ships a `commit-msg` hook. Enable it once after cloning:

```bash
git config core.hooksPath .githooks
```
