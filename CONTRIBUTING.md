# Töhfə qaydaları

## Branch strategiyası (Git flow)

| Branch | Məqsəd |
|---|---|
| `main` | Production-a hazır kod. Yalnız `release/*` və `hotfix/*` merge olunur. |
| `develop` | İnteqrasiya branch-ı. Bütün feature-lar bura merge olunur. |
| `feature/<qisa-ad>` | Yeni funksionallıq. `develop`-dan açılır, PR ilə `develop`-a qayıdır. |
| `release/<versiya>` | Buraxılışa hazırlıq. `develop`-dan açılır, `main` və `develop`-a merge olunur. |
| `hotfix/<qisa-ad>` | Production-da təcili düzəliş. `main`-dən açılır, `main` və `develop`-a merge olunur. |

Nümunə: `feature/parking-geo-search`, `hotfix/booking-double-reserve`

`main` və `develop`-a birbaşa push edilmir — yalnız Pull Request ilə.

## Commit mesajları (Conventional Commits)

```
<type>(<scope>): <qısa təsvir>

[ətraflı izah]

[footer: BREAKING CHANGE: ..., Closes #123]
```

**type:** `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`

**scope** (istəyə bağlı): servis və ya sahə adı — `gateway`, `user`, `parking`, `booking`, `payment`, `notification`, `infra`, `docs`

Nümunələr:
```
feat(parking): add nearby parking search with PostGIS
fix(booking): prevent double reservation of same slot
chore(infra): add Kafka UI to docker-compose
feat(user)!: change JWT claims format
```

### Commit mesajı yoxlaması

Repo-da `commit-msg` hook-u var. Klonladıqdan sonra bir dəfə aktivləşdirin:

```bash
git config core.hooksPath .githooks
```
