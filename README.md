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


### Required Environment Variables

To run this app you will need to set the following
[environment variables](https://en.wikipedia.org/wiki/Environment_variable):

+ PORT
+ GITHUB_CLIENT_ID
+ GITHUB_CLIENT_SECRET
+ GITHUB_KEY  (this is only temporary)

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


### name

> see: https://translate.google.com/#pt/en/tudo

###Front-end

@msmichellegar and @iteles have styled three screens for the project: the "login"/landing page, the home feed, and an issue view. Original wireframes for these screens (and an archive of discussed designs) can be found [here](https://docs.google.com/presentation/d/11JJjfQ-MtnfnRGQT9KREmqUHQj4wkgB7tjSxXhXyNJg/edit#slide=id.p).

We have worked to a very stripped-down design for the MVP, and will be adding more functionality as agreed on by the dwyl community (customisation, organisation and repo views, toggle views).

<img width="600" alt="proposed-initial-stripped-down-design" src="https://cloud.githubusercontent.com/assets/4185328/8803847/24905988-2fc1-11e5-8a10-754ab36236ad.png">

<img width="280" alt="proposed-initial-stripped-down-design" src="https://cloud.githubusercontent.com/assets/10683087/8856303/ed930078-3161-11e5-9f84-edadadaa885a.png">

## Github API - issues

Please make sure you have an env.json file based upon env.json_sample.

The only issues you will be able to get (for now, until authentication is integrated) are issues that only you can see (or whoever's GitHub access token you're using). These issues can be filtered using the following filters:
- **all:** to get all the issues a user can see
- **assigned:** to get all the issues assigned to a user
- **created:** to get all the issues created by a user
- **subscribed:** to get all the issues to which a user is subscribed
- **mentioned:** to get all the issues that mention a user

The default issue object returned by a query to the GitHub API contains a 'comments_url' that links to all the issue's comments. We push the comment information to each issue in the newly created 'comment_items' property.

Issues are returned in an array of objects; an example of issues, including the 'comment_items' property, can be viewed in example_issues.json.

This should be a transferrable function - easily implemented in a handler or incorporated into the existing database functions.


## Database Structure

Issues and Users are stored as hashes in Redis.  
A user's list of issues is stored as a sorted (by date of update) set.  
All users are also stored in an unsorted set.

An issue hash has the following properties:
+ id  
+ created_by
+ owner_name
+ repo_name
+ title
+ first_line
+ labels
 + name
 + color
+ updated_at
+ created_at
+ last_comment
+ number_of_comments
+ issue_number
+ assignee

A user hash has the following properties:
+ username

To get a users issues, we have the function in _fetch_issues_by_user.js_, which adds the user to the database if they don't already exist, and gets their issues, from the database if they are there, otherwise from the github api.

###**Glossary**

####Labels

Labels are used to organise issues into logical groups. An issue can have multiple labels. GitHub provide us with the following examples:


 - **bug:** *a software defect (incorrect step, process or data definition) that causes a failure.*
 - **duplicate**: *when the same GitHub issue has been created twice.*
 - **enhancement**: *is an improvement to a repository( this can be a new feature or a refinement of the code and file structure)*
 - **help wanted**: *a request for external contribution to an issue with defined objectives from someone within your organization or the GitHub community.*
 - **invalid**: *issue is not relevant.*
 - **question**: *A question relating to a repository.*
 - **wontfix**: *a refusal from another person to fix an issue.*

We think issue categorisation through the use of labels can really improve organisation. Here are a few of the dwyl provided labels that we find useful:

####Time
- **time-estimate:{time in minutes}**:  *the estimated time that you think is needed to complete an issues objectives.*
- **time-actual:{time in minutes}**: *the actual time that it took for an issues objectives to be completed.*
- **time-unestimated**: *when the an issue has no time-estimate.*
####Priority
- **priority-1**: * the contents of an issue are of highest priority and if it contains tasks they must be completed asap (an example would be a bug which has crashed a live application) .*
- **priority-2**: *not as high a priority as priority-1 but still pretty important.*
- **priority-3**: *issues labeled with this are not very important this could include a minor amendment to a sites contents.*

####Other

 - **ice-box**: *issues that do not have to be acted upon until a later date. *
 - **dependency**: *when an something external is preventing an issue from being completed.*

##Components

Components for the login, home and issue page are located in the views/tags folder. All tags are rendered on the server side by using the render function from Riot.js.
