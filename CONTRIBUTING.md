# Contributing to the project

We would love for you to contribute to this project and help make it even
better than it is today! As a contributor, here are the guidelines we would
like you to follow:

 - [Coding Rules](#rules)
 - [Commit Message Guidelines](#commit)

## <a name="rules"></a> Coding Rules
To ensure consistency throughout the source code, keep these rules in mind as
you are working:

* All features or bug fixes **must be tested** by one or more tests.
* All public API methods **must be documented**.

## <a name="commit"></a> Commit Message Guidelines

We have very precise rules over how our git commit messages can be formatted.
This leads to **more readable messages** that are easy to follow when looking
through the **project history**.

### Commit Message Format Each commit message consists of a **header**, a
**body** and a **footer**.  The header has a special format that includes a
**type**, a **scope** and a **subject**:

```
<type>(<scope>): <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

The **header** is mandatory and the **scope** of the header is optional.

Any line of the commit message cannot be longer 100 characters! This allows the
message to be easier to read on GitHub as well as in various git tools.

The footer should contain a [closing reference to an
issue](https://help.github.com/articles/closing-issues-via-commit-messages/) if
any.

### Revert
If the commit reverts a previous commit, it should begin with `revert: `,
followed by the header of the reverted commit. In the body it should say: `This
reverts commit <hash>.`, where the hash is the SHA of the commit being
reverted.

### Type
Must be one of the following:

* **ci**: Changes to our CI configuration files and scripts
* **docs**: Documentation only changes
* **feat**: A new feature
* **fix**: A bug fix
* **perf**: A code change that improves performance
* **refactor**: A code change that neither fixes a bug nor adds a feature
* **style**: Changes that do not affect the meaning of the code (white-space,
  formatting, missing semi-colons, etc)
* **test**: Adding missing tests or correcting existing tests
* **chore**: Other simple/generic change
