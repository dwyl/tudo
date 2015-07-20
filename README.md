# tudo

A single version of the truth with integrated task tracking, delegation and accountability.

## Why?

We have all experienced working at an organisation where communication,
delegation and follow-through were *sub-optimal*.

***tudo*** is our quest to help *all* organisations have a
"[***Single version of the truth***](https://en.wikipedia.org/wiki/Single_version_of_the_truth)""
which is *always* consistent, version-controlled (*full audit/history*),
transparent and real-time.

## Run the APP

### Required Environment Variables

To run this app you will need to set a few environment variables:
+ PORT
+ Github API Client
+ GitHub API Secret

If you prefer to use a file to store these variables,
create a file called env.json and put it at the root of the project.
This repo contains a sample file: `env.json_sample` which youc an copy:
```sh
cp env.json_sample env.json
```
And then change the values as required.

## Background Reading

### GitHub Authentication

+ We are using Bell for our authentication: https://github.com/hapijs/bell
+ https://developer.github.com/guides/basics-of-authentication/


## tl;dr

### name ?

> see: https://translate.google.com/#pt/en/tudo
