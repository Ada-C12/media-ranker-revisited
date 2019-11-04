# Media Ranker
## What We're Looking For

<!-- Reviewer Instructions: Limit your in-line comments on this one. Also, the manual testing is huge, but covers eeeeverything, so if there's anything to comment on as constructive feedback, the manual testing should point you right to it with any line that has the answer "no" -->

### Manual Testing

Workflow | yes / no
--- | ---
Deployed to Heroku | 
Look and feel is similar to the original (consider styling and layout) | 
**Before logging in** |
On index page, there are at most 10 pieces of media on three lists, and a Media Spotlight | 
Can go into a work's show page | 
Verify unable to vote on a work, and get a flash message | 
Can edit this work successfully, and get a flash message | 
Can go to "View all media" page and see three lists of works, sorted by vote | 
Verify unable to create a new work when the form is empty, and details about the validation errors are visible to the user through a flash message | 
Can create a new work successfully. Note the URL for this work's show page | 
Can delete this work successfully |
Going back to the URL of this deleted work's show page produces a 404 or some redirect behavior (and does not try to produce a broken view) | 
Verify that the "View all users" page lists no users | 
**Log in** | 
Logging in with a valid name changes the UI to "Logged in as" and "Logout" buttons | 
Your username is listed in "View all users" page | 
Verify that number of votes determines the Media Spotlight | 
Voting on several different pieces of media affects the "Votes" tables shown in the work's show page and the user's show page | 
Voting on the same work twice produces an error and flash message, and there is no extra vote | 
**Log out** |
Logging out showed a flash message and changed the UI | 
Logging in as a new user creates a new user | 
Logging in as an already existing user has a specific flash message | 

### Targeted Code Review

Area | yes / no
--- | ---
git commits were small and atomic, with useful messages | 
Routes file uses `resources` for works |
Routes file shows intention in limiting routes for voting, log-in functionality, and users | 
The homepage view, all media view, and new works view use semantic HTML | 
The homepage view, all media view, and new works view use partials when appropriate | 
The model for media (likely named `work.rb`) `has_many` votes | 
The model for media has methods to describe business logic, specifically for top ten and top media, possibly also for getting works by some category | 
Some controller, likely the `ApplicationController`, has a controller filter for finding a logged in user | 
Some controller, likely the `WorksController`, has a controller filter for finding a work | 
The `WorksController` uses strong params | 
The `WorksController`'s code style is clean, and focused on working with requests, responses, `params`, `session`, `flash` | 

#### Targed Test Review

Area | yes / no
--- | ---
There are valid fixtures files used for users, votes, and works | 
User model has tests with sections on validations (valid and invalid) and relationships (has votes) | 
Vote model has tests with sections on validations (valid and invalid) and relationships (belongs to a user, belongs to a vote) | 
Work model has tests with sections on validations (valid and invalid) and relationships (has votes) | 
Work model has tests with a section on all business logic methods in the model, including their edge cases | 

## Overall Feedback

