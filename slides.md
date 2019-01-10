---
title: Terraform 101
author: Supanat Potiwarakorn
patat:
  incrementalLists: true
  slideLevel: 2
  wrap: true
  margins:
    left: 30
    right: 30
  pandocExtensions:
    - patat_extensions
    - autolink_bare_uris
    - emoji
...

# Terraform 101

## Problems

* want to version control infrastructure along with application
* simple and declarative, not just bunches of messy shell script

## Terraform to rescue!

* define infrastructure as code declaratively
* reproducible
* idempotent
* easier to manage than GUI in many cases
* modules for abstraction

# Time to code!
## Let's build "My Crush" bot

```
   ____________________ (reply) _____________________
  |                                                  |
  v                                                  |
Line -- (webhook) --> API Gateway -- (invoke) --> Lambda
```
