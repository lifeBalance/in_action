# Ticketee
**Ticketee** is the ticket-tracking application that the [Rails 4 In Action][1] book uses to teach a lot of awesome stuff. What I'm liking the most about this app, is that is being developed using [BDD][2] best practices.

I'm really enjoying this book, which I consider to be one of the best resources for learning Rails 4.

Some of the stuff covered by the book:

## Chapter 1
This chapter is just an overview of the Rails framework, covering basic stuff like:
* Installation (Actually this is covered in appendix A)
* Generating an app and starting it.
* The `scaffold` command.
* Migrations.
* Views.
* Model validations.
* Very basic routing.

All of it using a small toy app.

## Chapter 2
About how combining a [TDD][3] plus [BDD][2] approach can help us save our bacon and our sanity. The gems used for accomplish that are [RSpec][4] and [Capybara][5].

## Chapter 3
Here we start building the **Ticketee** app. It explains very basic [git][6] on [GitHub][7], and routing according to the Rails' team interpretation of the [REST architecture][8], and
how the 7 standard REST actions map to the 4 CRUD database operations.

## Chapter 4
It keeps building on [CRUD][9], and introduces [factory_girl gem][10] as an easier alternative to fixtures for feeding mock data to our tests.
Also covered the [bootstrap-sass gem][11] for pimping up the app, which honestly I couldn't care less, and found a bit distracting. A lot of bootstrap styling takes place but also introduces the awesome [simple_form gem][12] for easier form generation.

## Chapter 5
Now things start to get interesting with the introduction of **nested resources** and **callbacks**. The authors here explain how to use **nested routing helpers** that are automatically available after defining `tickets` as a nested resource (inside `projects`) in our routes.

## Chapter 6

## Chapter 7

## Chapter 8
1. Creating a `Role` model. Each record of the corresponding database table for this model, contains the role that a given user has on a specific project:

* Viewer: Read a specific project object.
* Editor: Same as above plus creating and updating ticket objects on a given project.
* Manager: Same as above plus editing project details.

2. Implementing a **whitelist authorization** system.
3. Use of the [Pundit gem][13]
4. During the whole chapter plenty of **feature tests** are written or previous tests are modified to check the permissions that restrict access to the CRUD actions on the `ProjectsController` and `TicketsController`. These permissions are granted by `Role` objects.
5. Finally, we implement the functionality that allow admins to assign roles to users.

## Chapter 9
This chapter is mostly about file uploading using the [carrierwave gem][14], but it teaches other useful things like:

* Removing the [turbolinks gem][15] from our application.
* Small introduction to [CoffeeScript][16] using a small script for helping when adding fields for uploading files.

## Chapter 10
In this part of the book we develop a feature for adding information about the state of a ticket. This is done using a select field in the comments.

We also implement the functionality that allows admins to add new states to the list, so users have more options to choose from. Admins also can rename, remove and set a default state so new tickets are never born stateless.

As usual the work start writing a BDD feature to describe the process of creating a state, and as always we walk our way to the final implementation by writing the minimal amount of code necessary to fix the spec failures.

[1]: https://www.manning.com/books/rails-4-in-action
[2]: https://en.wikipedia.org/wiki/Behavior-driven_development
[3]: https://en.wikipedia.org/wiki/Test-driven_development
[4]: https://relishapp.com/rspec
[5]: http://www.rubydoc.info/github/jnicklas/capybara/master
[6]: https://git-scm.com/
[7]: https://github.com/
[8]: https://en.wikipedia.org/wiki/Representational_state_transfer
[9]: https://en.wikipedia.org/wiki/Create,_read,_update_and_delete
[10]: https://github.com/thoughtbot/factory_girl/tree/master
[11]: https://github.com/twbs/bootstrap-sass
[12]: http://simple-form.plataformatec.com.br/
[13]: https://github.com/elabs/pundit
[14]: https://github.com/carrierwaveuploader/carrierwave
[15]: https://github.com/rails/turbolinks
[16]: http://coffeescript.org/
