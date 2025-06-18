

set -e

PACKAGE_MANAGER=${1:-npm}

# 1. Check and install jq
echo "🔍 Checking if jq is installed..."
if ! command -v jq &> /dev/null; then
  echo "❌ jq not found. Attempting to install..."
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt-get update && sudo apt-get install -y jq
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install jq
  else
    echo "⚠️ Unsupported OS. Please install jq manually: https://stedolan.github.io/jq/download/"
    exit 1
  fi
else
  echo "✅ jq is installed"
fi

# 2. Git init if not already initialized
if [ ! -d ".git" ]; then
  echo "🔧 Initializing Git repository..."
  git init
else
  echo "✅ Git is already initialized"
fi

# 3. Install dev dependencies
echo "📦 Installing dev dependencies using $PACKAGE_MANAGER..."

DEPS="husky lint-staged prettier eslint eslint-config-prettier eslint-plugin-prettier typescript-eslint"

if [ "$PACKAGE_MANAGER" = "yarn" ]; then
  yarn add --dev $DEPS
else
  npm install --save-dev $DEPS
fi

# 4. Husky setup
echo "🐶 Initializing Husky..."
npx husky-init

if [ "$PACKAGE_MANAGER" = "yarn" ]; then
  yarn
else
  npm install
fi

# 5. Add pre-commit hook
echo "🪝 Adding pre-commit hook..."
npx husky add .husky/pre-commit "npx lint-staged"

# 6. Update package.json using jq
echo "🧠 Updating package.json..."
TMP_FILE=$(mktemp)
jq '.scripts.test = "echo \"No tests yet\" && exit 0"
    | .scripts.prepare = "husky install"
    | . + {
        "lint-staged": {
          "*.{js,jsx,ts,tsx,json,css,scss,md}": [
            "prettier --write",
            "eslint --fix"
          ]
        }
      }' package.json > "$TMP_FILE" && mv "$TMP_FILE" package.json

# 7. Prettier config
echo "✨ Creating .prettierrc.json..."
cat <<EOT > .prettierrc.json
{
  "semi": true,
  "singleQuote": true,
  "printWidth": 120,
  "trailingComma": "es5"
}
EOT

# 8. ESLint config
echo "🧹 Creating eslint.config.js..."
cat <<'EOT' > eslint.config.js
import prettier from 'eslint-plugin-prettier'
import tseslint from 'typescript-eslint';

export default tseslint.config(
  {
    files: ['**/*.js', '**/*.jsx', '**/*.ts', '**/*.tsx'],
    languageOptions: {
      ecmaVersion: 2021,
      sourceType: 'module',
    },
    plugins: {
      prettier,
    },
    rules: {
      'prettier/prettier': 'error',
      'semi': ['warn', 'always'],
    },
  },
);
EOT

# 9. Set permissions for Husky hooks
echo "🔐 Setting Husky hook permissions..."
chmod +x .husky/pre-commit
chmod +x .husky/_/husky.sh

# 10. Optional: Make initial commit
if [ -z "$(git status --porcelain)" ]; then
  echo "📂 Making initial commit..."
  git add .
  git commit -m "chore: initial project setup with linting and hooks"
else
  echo "📂 Skipping commit — changes already exist."
fi

echo "✅ Setup complete! Test it by staging and committing a file."
