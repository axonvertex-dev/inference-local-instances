# Repository Setup

Recommended repository name:

```text
inference-local-instances
```

## Initialize locally

From the parent directory:

```bash
cd inference-local-instances
git init -b main
git config user.name "Krishnendu Dasgupta"
git config user.email "axonvertex@gmail.com"
cp .env.example .env
chmod 600 .env
./scripts/validate-repo.sh
git add .
git commit -m "Initial release: local small-instance inference cookbooks"
```

The `.env` file is ignored and must not appear in `git status --staged`.

## Create the GitHub repository

Create an empty repository under the `axonvertex-dev` account without automatically adding a README, license, or `.gitignore` because those files already exist locally.

Using GitHub CLI after authentication:

```bash
gh repo create axonvertex-dev/inference-local-instances \
  --public \
  --source=. \
  --remote=origin \
  --push
```

For a private repository, replace `--public` with `--private`.

## Verify the remote

```bash
git remote -v
git status
git log --oneline --decorate --graph -n 5
git ls-remote --heads origin
```

## First release checklist

1. Select and add a repository-level license if the repository will be public.
2. Review all upstream model and framework licenses.
3. Confirm `.env` is ignored.
4. Run `./scripts/validate-repo.sh`.
5. Test at least one host path before adding a release tag.
6. Replace `latest` container tags with tested version tags when reproducibility is required.
