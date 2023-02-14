#!/bin/bash

if [ -z "$1" ]; then
  echo "Error: project name is not set"
  echo "Error: please call it as ' create-ts-project.sh your-new-poroject' name is not set"
  exit 1
fi


APP_NAME=$1

# Install Node.js and TypeScript
echo "npm install -g node typescript"

echo "# Create a new directory for the project"
mkdir $APP_NAME

cd $APP_NAME

echo "# Initialize a new npm project"
npm init -y

echo "# Install dependencies"
npm install express @types/express
npm install -D eslint prettier ts-node nodemon
npm install typescript

echo "# Create a eslint config file"
echo '{
    "env": {
        "browser": true,
        "commonjs": true,
        "es2021": true
    },
    "extends": "eslint:recommended",
    "globals": {
        "__dirname": true,
        "process": true
    },
    "overrides": [
    ],
    "parserOptions": {
        "ecmaVersion": "latest"
    },
    "rules": {
        "no-async-promise-executor": "off"
    }
}' > .eslintrc.json

echo "# Run eslint init with the config file"
npx eslint --init -c .eslintrc.json --no-interactive

echo "# Create a TypeScript configuration file"
npx tsc --init

echo "# Create a "src" directory for TypeScript code"
mkdir src

# Update the "outDir" option in tsconfig.json to point to "dist" directory
sed -i 's/"outDir": "./"outDir": "dist",/' tsconfig.json

echo "# Create VS Code launch.json file"

mkdir .vscode

echo '{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "node",
            "request": "launch",
            "name": "Launch Program",
            "program": "${workspaceFolder}/src/index.ts",
            "cwd": "${workspaceFolder}",
            "runtimeArgs": ["-r", "ts-node/register"]
        },
        {
            "type": "node",
            "request": "launch",
            "name": "Run current TypeScript file",
            "program": "${file}",
            "cwd": "${workspaceFolder}",
            "runtimeArgs": ["-r", "ts-node/register"]
        }
    ]
}' > .vscode/launch.json

echo "# Add start script to package.json"
jq '.scripts.start = "nodemon --exec ts-node src/index.ts"' package.json > package.json.tmp && mv package.json.tmp package.json