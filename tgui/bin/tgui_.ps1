## Copyright (c) 2020 Aleksej Komarov
## SPDX-License-Identifier: MIT

## Initial set-up
## --------------------------------------------------------

## Enable strict mode and stop of first cmdlet error
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$PSDefaultParameterValues['*:ErrorAction'] = 'Stop'

## Validates exit code of external commands
function Throw-On-Native-Failure {
  if (-not $?) {
    exit 1
  }
}

## Normalize current directory
$basedir = Split-Path $MyInvocation.MyCommand.Path
$basedir = Resolve-Path "$($basedir)\.."
Set-Location $basedir
[Environment]::CurrentDirectory = $basedir


## Functions
## --------------------------------------------------------

function Remove-Quiet {
  Remove-Item -ErrorAction SilentlyContinue @Args
}

function task-install {
  yarn install
}

## Runs webpack
function task-webpack {
  yarn run webpack-cli @Args
}

## Runs a development server
function task-dev-server {
  yarn node "packages/tgui-dev-server/index.js" @Args
}

## Run a linter through all packages
function task-lint {
  cd "${base_dir}"
  eslint ./packages "${@}"
  echo "tgui: eslint check passed"
}

## Mr. Proper
function task-clean {
  ## NPM artifacts
  Get-ChildItem -Path "." -Include "node_modules" -Recurse -File:$false | Remove-Item -Recurse -Force
  Remove-Quiet -Force "package-lock.json"
}


## Main
## --------------------------------------------------------

if ($Args.Length -gt 0) {
  if ($Args[0] -eq "--clean") {
    task-clean
    exit 0
  }

  if ($Args[0] -eq "--dev") {
    $Rest = $Args | Select-Object -Skip 1
    task-install
    task-dev-server @Rest
    exit 0
  }

  if ($Args[0] -eq "--lint") {
    $Rest = $Args | Select-Object -Skip 1
    task-install
    task-lint @Rest
    exit 0
  }

  if ($Args[0] -eq "--lint-harder") {
    $Rest = $Args | Select-Object -Skip 1
    task-install
    task-lint -c ".eslintrc-harder.yml" @Rest
    exit 0
  }

  if ($Args[0] -eq "--fix") {
    $Rest = $Args | Select-Object -Skip 1
    task-install
    task-lint --fix @Rest
    exit 0
  }

  if ($Args[0] -eq "--test") {
    $Rest = $Args | Select-Object -Skip 1
    task-install
    task-test @Rest
    exit 0
  }

  ## Analyze the bundle
  if ($Args[0] -eq "--analyze") {
    task-install
    task-webpack --mode=production --analyze
    exit 0
  }
}

## Make a production webpack build
if ($Args.Length -eq 0) {
  task-install
  task-lint
  task-webpack --mode=production
  exit 0
}

## Run webpack with custom flags
task-install
task-webpack @Args
