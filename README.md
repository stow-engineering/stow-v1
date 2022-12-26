<a href="https://github.com/stow-engineering/stow-v1/actions"><img src="https://github.com/stow-engineering/stow-v1/workflows/test-my-app/badge.svg" alt="Build Status"></a>
# Stow Beta Release

## __TO DO in README__:
- [ ] Add environmental variables to be set in local machine
- [ ] Setup section for CD w/ CodeMagic, TestFlight

This repository contains source code for the beta release of the Stow iOS mobile application.

## Flutter Commands

- `flutter doctor`: local development environment verification
- `flutter pub get`: download dependencies in `pubspeck.yaml`
- `flutter pub update`: update flutter packages
- `flutter pub add {package}`: add package as dependency
- `flutter test`: run tests

## Submitting Changes TL;DR
-  Commit changes - this will run pre-commit check
- `git pull --rebase origin main`
- `git rebase -i HEAD~{NUMBER OF COMMITS MADE}`
- Open PR, request review from at least one team member
- Upon approval, merge in changes

## Submitting Changes

__Note__: These conventions are based on experience but if you know a __better way, let the team know!__

Prior to opening a PR the following should be done to rebase your new branch with the upstream and then squash into a single commit (reference this Stack Overflow ):

- `git pull --rebase origin main`
- `git rebase -i HEAD~{NUMBER OF COMMITS MADE}`: this allows for squashing all the commits into a single commit that can be submitted for the PR - choose the squash option for the commit you want to merge in the others. E.g., if you have two commits you want to squash together, the command you would run is `git rebase -i HEAD~2`.

The reasoning behind squashing the commits into a single commit is that it will allow for easier rollbacks - because we have a one-to-one commit to issue relationship, if we want to revert a feature contribution, we only have to revert a single commit.

## Conventions & Organization
- __Feature-First Organization__: to better structure the application, we will follow the feature-first approach, where we have features as the first layer and implementation in subdirectories. This is inspired by this [article](https://codewithandrea.com/articles/flutter-project-structure/) which explains the approach.
- __Commits__: To standardize commits, we can follow the "conventional commits" approach that includes a keyword describing the type of commit followed by a brief description. We don't have to follow this exactly - the [specification](https://www.conventionalcommits.org/en/v1.0.0/#specification) is provided here:
    - `ci/cd`
    - `doc`
    - `feature`
    - `fix`
    - `refactor`
    - `revert`
    - `test`

## Automation Tools
- __GitHub Actions__: defined in the `.github/workflows/testing.yml` file; these are run when a changes are merged into `main`
- __Pre-commit__: hooks ran when running "git commit..." command locally
  - Run: `brew install pre-commit` (if not using brew, refer to the [pre-commit documentation](https://pre-commit.com/))
  - Install git hooks:`pre-commit install`
  - Run: `pre-commit run --all-files`
- __CodeMagic__: CI/CD tool
