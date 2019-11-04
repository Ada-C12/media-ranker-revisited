# Media Ranker

## At a Glance

- Individual, [stage 2](https://github.com/Ada-Developers-Academy/pedagogy/blob/master/rule-of-three.md#stage-2) project
- Due before class on Monday October 21, 2019

## Learning Goals

The purpose of this assignment is to reinforce the following concepts:

- Previous Rails learning, including MVC, RESTful routing, and the request cycle
- Testing Rails applications
- Building complex model logic
- Using `session` and `flash` to track data between requests
- DRYing up Rails code

## Objective

We will build a Rails webapp where users can vote for their favorite pieces of media.

In contrast to previous projects, instead of implementing a pre-defined spec, you will be imitating an existing site: http://media-ranker-2-0.herokuapp.com. Your job is to match the functionality and styling of this site as closely as possible.

## Getting Started

Before you start writing _any_ code, do the following steps. Spend no more than 1.5 hours on this:

1. Explore the existing Media Ranker site to become familiar with the necessary functionality. Pair up with others to discuss observations and talk about what users can see and can do. Pay attention to routes and redirects.
1. Consider a list of possible routes, controllers, and models
1. Create a first draft of an ERD for the models. Consider checking in with others about how ERDs.
1. Create a Trello board to manage user stories and begin to create tasks that represent project setup and wave 1

Then, once you have a solid plan for how to structure your project, follow these steps to start coding:

- Fork and clone the repo
- Use `rails new .` to generate a new Rails project in the cloned directory
  - Do not overwrite the project README
- Create a first commit using `git add .` and `git commit -m "Initial Rails setup"`

### Regarding the Word "Media"

Our project is called Media Ranker, and revolves around voting on media. You may suspect that "A Single Piece of Media," or "Media," is going to be a model.

However, the Rails inflector considers "media" to be the plural of "medium", which is not really what we mean here. You may want to choose a different word to represent "a book, movie or album" internally. The instructor-proved example site uses the word "work".

### What We've Included

Inside of the `db` folder, we have included two files:

- `media-seeds.csv`
- `generate_starter_data.rb`

You are encouraged to build your own `seeds.rb` script using the `media-seeds.csv` file, so that you can run `rails db:seed`. You are encouraged to reference other seeds scripts you may have!

The file `generate_starter_data.rb` is a script to help generate a new `media-seeds.csv` file. There are comments in the file about its use. You are not required to use this file.

---

# Non-Functional Requirements

Regardless of how you choose to implement this project or how it progresses over time, your workflow should exhibit:

- Squeaky-clean **git hygiene**, including
  - A fresh branch for each new feature
  - Regular commits
  - Descriptive commit messages
- Fanatical devotion to **testing the model**
  - Pseudocode first, then write the tests, then write code to make them pass (with the exception of when we encourage otherwise)
  - **Note:** This project has no requirements around writing controller tests; instead, our prioritized learning goal this week is model tests. We will revisit controller tests immediately after this project.
- Steadfast adherence to **agile development practices**
  - User stories should be listed and prioritized using a Trello board
  - The finished application should be deployed to Heroku (deploy early, deploy often)
- Unrelenting use of **semantic HTML**

# Functional Requirements

## Wave 1

In this wave, you should build some functionality, and then build the model tests relevant to that functionality. We recommend doing the read and create operations first, then writing tests, then completing the update and delete operations.

Mimic the site's basic functionality around Media, without worrying (yet) about Users or Votes:
- Build a main page, with a list of the media for each category, as well as a spotlight section for the top media overall.
    - Since we don't have votes yet, for both the spotlight and top-10 sections you should select works at random (i.e. using `.sample`)
- Build an index page with a list of all works for each category
- Allow users to add new works
- Build a details page for each piece of media
- Allow users to edit and delete works

### Hints for Refactoring

Think about what logic should live in the model. Given that the way you select the spotlight and top-10 are going to change in a future wave, how can you isolate this business logic to make it easy to change?

### Required Testing: Models

**Before** moving on to wave 2, your project should contain the following tests:

- All validations and should be tested
- All custom methods should be tested
    - For top-10 or spotlight, what if there are less than 10 works? What if there are no works?

### Optional Testing: Controllers

Consider these features and the tests that would go with them for your controllers. If it is helpful, write them and use them!

- Tests for standard CRUD operations on works
- Does the main page load if there are no works?

## Wave 2

Mimic the site's functionality around Users and Voting:
- Allow users to "log in" to the site, and use the `session` to keep track of which user is currently logged in for a given browser
- Allow users to vote for media
- Don't allow a user to vote for the same media more than once

Refactor your current site to utilize this new functionality:
- Change the media spotlight and top-10 to respect vote count
- All lists of media (including top ten lists on the front page) are sorted in a specific way on the demo site. How? Implement this sorting on your site

### Required Testing: Models

**Before** moving on to wave 3, your project should contain the following tests

- All validations for new models should be tested
- All relations between models should be tested
- Your tests for custom model methods should be updated to reflect the presence of votes
    - How do top-10 and spotlight handle works with no votes? Ties in the number of votes?


### Optional Testing: Controllers

Consider these features and the tests that would go with them for your controllers. If it is helpful, write them and use them!

- Tests for all individual actions
- Authentication tests combining multiple actions
    - A guest user _cannot_ vote if they have not logged in
    - A logged-in user _can_ vote for a work they haven't already voted for
    - A logged-in user _cannot_ vote for a work they have previously voted for

Focus on the tests for voting logic since this is the most complex part of Wave 2.

### A note on logging in

Passwords and security are tricky! We'll talk about that sort of thing a little in the coming weeks, but for now you don't need to provide any sort of security. The user gives you a username, and your site should just trust them.

## Wave 3
- Add a list of voting users to the details page for each media
- Add a page for each user, as well as a page showing a summary of all users

## Optional Enhancements

### High Priority Optionals

1. Use Bootstrap and CSS to style the site to match the example. The layout as well as the look and feel should match as close as possible. Yes, you are free to use browser dev tools to inspect, read, and even copy/paste the styles from the demo page.
1. Write the controller tests for all CRUD operations
1. Write the controller tests for the nominal test cases of voting functionality
1. Write the controller tests for the edge test cases of voting functionality

### Low Priority Optionals

Once your test coverage is comprehensive, your HTML is semantic, your user stories have all been moved to the `Done` column and your application has been deployed to Heroku, you may consider the following enhancements:

1. DRY up your code as much as you can! Techniques worth investigating:
    - Helper methods
    - Controller filters
1. Build category-specific pages for `index` and `new` (e.g. `/books` or `/movies/new`). These should be as DRY as possible. You might be interested in investigating _polymorphic routes_.
1. Add a [recommendation system](https://www.toptal.com/algorithms/predicting-likes-inside-a-simple-recommendation-engine) that suggests media to a user based on what they have previously voted for.

## What we're looking for
You can find what instructors will be looking for in the [feedback](feedback.md) markdown document.
