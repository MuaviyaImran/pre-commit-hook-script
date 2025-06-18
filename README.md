# 🛠️ Dev Tools – Pre-Commit Hook Script

> Automate your project's code quality with **ESLint**, **Prettier**, **Husky**, and **lint-staged** — all with one script.

---

## 🚀 Features

- 🎯 **Automatic Setup** of ESLint, Prettier, Husky, and lint-staged
- 🔒 Adds a `pre-commit` Git hook that runs formatting and linting only on staged files
- 🧼 Creates config files for Prettier and ESLint (with Flat Config)
- ⚡ Supports `npm` and `yarn` package managers
- 🔧 Automatically installs missing tools like `jq`
- 📦 Works out-of-the-box for React + TypeScript projects

---

## ⚡ One-Liner Install

Run this in your terminal (from your project root):

```bash
curl -fsSL https://raw.githubusercontent.com/MuaviyaImran/pre-commit-hook-script/main/script.sh | bash
```

For Yarn

```
curl -fsSL https://raw.githubusercontent.com/MuaviyaImran/pre-commit-hook-script/main/script.sh | bash -s yarn
```

To test your setup, make some changes to your code and stage them using git add. Then, try to commit your changes. Husky and lint-staged should automatically run Prettier and ESLint to format and lint your code before the commit is finalized
