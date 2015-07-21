# tudo

A single version of the truth with integrated task tracking, delegation and accountability.

[![Build Status](https://travis-ci.org/dwyl/tudo.svg)](https://travis-ci.org/dwyl/tudo)
[![Test Coverage](https://codeclimate.com/github/dwyl/tudo/badges/coverage.svg)](https://codeclimate.com/github/dwyl/tudo/coverage)
[![Code Climate](https://codeclimate.com/github/dwyl/tudo/badges/gpa.svg)](https://codeclimate.com/github/dwyl/tudo)
[![Dependency Status](https://david-dm.org/dwyl/tudo.svg)](https://david-dm.org/dwyl/tudo)
[![devDependency Status](https://david-dm.org/dwyl/tudo/dev-status.svg)](https://david-dm.org/dwyl/tudo#info=devDependencies)

## Why?

We have all experienced working at an organisation where communication,
delegation and follow-through were *sub-optimal*.

***tudo*** is our quest to help *all* organisations have a
"[***Single version of the truth***](https://en.wikipedia.org/wiki/Single_version_of_the_truth)""
which is *always* consistent, version-controlled (*full audit/history*),
transparent and real-time.

## Run the APP

### Required Environment Variables

To run this app you will need to set the following
[environment variables](https://en.wikipedia.org/wiki/Environment_variable):

+ PORT
+ GITHUB_CLIENT_ID
+ GITHUB_CLIENT_SECRET

#### Local Machine (_use an `env.json` file_)

On your personal development machine
you can use an `env.json` file to store these environment variables,
create a file called env.json and put it at the root of the project.

This repo contains a sample file: `env.json_sample` which you can copy:
```sh
cp env.json_sample env.json
```
And then change the values as required.
(aksk @iteles for access to the Google Doc with our env.json )

#### Deploying on Heroku

To deploy to Heroku you will need to add the environment variables _manually_ (_once_)

![heroku-config-variables](https://cloud.githubusercontent.com/assets/194400/8795158/59ca2e06-2f82-11e5-81f4-07dee9bb3d4b.png)


## Background Reading

### GitHub Authentication

~~ We are using Bell for our authentication: https://github.com/hapijs/bell ~~
+ https://developer.github.com/guides/basics-of-authentication/


## tl;dr

### name ?

> see: https://translate.google.com/#pt/en/tudo
