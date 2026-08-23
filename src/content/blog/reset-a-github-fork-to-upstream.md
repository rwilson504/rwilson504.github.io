---
title: "Reset a GitHub Fork to Upstream"
description: "Force a fork's master branch to match the upstream repository after accidental commits or a long period without syncing."
pubDate: 2020-06-03
category: dev-tools
tags:
  - "git"
  - "github"
  - "fork"
  - "source-control"
  - "dev-tools"
draft: true
---

Getting started with Git can get confusing at times.  Recently when looking back at one of the first projects I forked from GitHub (DefinitelyTyped) I realized I had done commits in my master branch instead of creating a branch.  I wanted to be able to merge changes back into the fork source so I figured it would be a good idea to reset my forked master back to the original git repo.  Also if you forked master is far behind the origin master you can also use this to bring your fork master up to date.

Here is the script for forcing your forked master to match the current origin master.

> **Warning:** `git reset --hard` discards local changes and the force push rewrites the remote branch. Back up any commits you need before running these commands.

```
cd C:\path\to\DefinitelyTyped
git remote add upstream /url/to/original/repo
git fetch upstream
git checkout master
git reset --hard upstream/master
git push origin master --force
```