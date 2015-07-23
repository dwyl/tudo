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
**20150720:** @msmichellegar, @iteles and Anneka S brainstormed on some front-end visuals and created some simple wireframes:
https://docs.google.com/presentation/d/11JJjfQ-MtnfnRGQT9KREmqUHQj4wkgB7tjSxXhXyNJg/edit#slide=id.p

<img width="918" alt="proposed-initial-stripped-down-design" src="https://cloud.githubusercontent.com/assets/4185328/8803847/24905988-2fc1-11e5-8a10-754ab36236ad.png">

#####Challenges:
+ What is the ideal user flow throughout the app? How do typical people (technical and non-technical) find the issues they're looking for?  
+ How do we ensure that issues are _not_ buried **more than 1 click deep**?

Earlier conversations yielded many different priorities when using Github issues so understanding what would be useful as a **default homepage** (prior to adding _customisation of content_) was interesting.
We agreed that **for now we would start with a stripped down version** that shows two things:
+ A list of issues as seen by a person when they go to http://github.com/issues
+ One additional view, filtering all issues assigned to the login in person

_Features such as search, prioritisation, creation of issues and creation of labels, etc will be added as they are agreed on by the group at [#dwylsummer](https://github.com/dwyl/summer-2015)._

#####Cards vs rows
Many conversations were had on this visual difference between items as 'cards' or items as 'rows'.

<img width="899" alt="screen shot 2015-07-21 at 19 43 34" src="https://cloud.githubusercontent.com/assets/4185328/8809534/2effbd4e-2fe1-11e5-91d8-46adf0210549.png">

_Cards_ encourage people to move them around and provide a greater visual differentiation between the various items. This will only become relevant if issues can be picked up and moved around to redetermine prioritisation.

## Github API - issues

You will temporarily need a env.json file (like below) to run this code.
```
{
    "GITHUB_KEY": "your personal acccess token"
}
```
The only issues you will be able to get (for now) are issues assigned to you by visiting localhost:8000/issues

This begins our exploration into the Github API - Issues.

Issues will be returned in an array. If you would like to see  an example of an issue then checkout the exampleOfBasicIssue.json provided. This is only basic does not have comments on and therefore a further request to the github API is needed to decorate further.

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
