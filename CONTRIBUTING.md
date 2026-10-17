# Contributing

## Branches

- `main` holds stable code. Never push directly to it.
- Work in your own branch: `feature/<name>`, `fix/<name>` or `docs/<name>`.
- Use lowercase letters and hyphens, e.g. `feature/routine-screen`.

## Workflow

1. Update your local copy: `git checkout main` then `git pull`
2. Create a branch: `git checkout -b feature/short-name`
3. Work and commit in small steps
4. Push your branch: `git push -u origin feature/short-name`
5. Open a Pull Request on GitHub
6. A teammate reviews it, then it is merged into `main`

## Commit messages

Short and clear, starting with a verb: `Add routine screen`, `Fix button color`.

## Never commit

Build folders, passwords, API keys, or app signing keys.