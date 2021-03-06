# Ticketee
**Ticketee** is a ticket-tracking application à la [lighthouse](https://lighthouseapp.com/). The [Rails 4 In Action][1] book uses this app as a vehicle to teach about building Rails apps following a professional approach according to [BDD][2] best practices.

> You know these books that look very serious and professional, they promise a lot but after a few pages you end up pulling your hair while following building the project? Well, this is **not** that kind of book. If something is not working, check your code and compare with the book, you can be sure you've done something wrong. I'm really enjoying [Rails 4 In Action][1], which I(and a lot more people) consider to be one of the best resources for learning Rails 4.

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

As usual the work start writing a BDD feature to describe the process of **creating a state**, and as always we walk our way to the final implementation by writing the minimal amount of code necessary to fix the spec failures.

The same procedure described above is followed for defining a method that allows setting a **default state** for tickets. With that method in place we just have to call that method every time a new ticket is created, and a **callback** in the `Ticket` model is perfect for that task, but only after a slight adjustment in the description of our feature for creating tickets.

Then we write another spec for the following requirement: **Editors** of a project should be able to leave comments but not change a ticket’s state; only **managers** of a project (and **admins**) can change the state.

Finally we implement functionality to avoid little rascals from tampering with our forms and changing a ticket state. We do that by modifying the `create` action in our `CommentsController` so that the `state_id` parameter is removed before being passed to the `build` method, for all users other than **managers** and **admins**. As usual, the actual implementation is preceded by a spec feature.

## Chapter 11
This chapter covers tagging tickets, meaning the ability to add **tags** to tickets so we can group them together under a given tag. Then we can use these tags to implement a search functionality based on them. Creating and editing tags is not gonna be allowed to all users, only **managers** of a project and **admins** will be able to do that.

### Creating tags
Creating tags is the first step, we need an interface for adding tags to new tickets, a simple **text field** underneath the ticket's description field. But before that, we need to add a new scenario to the spec for creating tickets. The steps taken to fix the failing spec:

* Create the text field itself for creating the tags in `views/tickets/_form.html.erb`.
* Creating a **virtual attribute** named `tag_names` inside the `Ticket` model.
* Add this attribute to the list of permitted parameters in `TicketsController`.
* Add markup for showing the tags in `views/tickets/show.html.erb`.
* Define the `tags` method with a `has_and_belongs_to_many` association between `Ticket` objects and `Tag` objects.
* Generate a `Tag` model with only a `name` field, and without any `timestamps` fields, we don't need them. Before running that migration, we generate another one for the **join table** for tags and tickets.
* Redefine the **setter method** for our virtual attribute `tag_names=` in the `Ticket` model.
* Creating a **partial template** for tags in `views/tags/_tag.html.erb` and add some styling.

### Adding more tags
Apart from adding tags upon ticket creation, every time we write a **comment** we should also be able of adding tags to an already existing ticket. For that we are gonna need to add another text field to our comment's form, but before that, as usual, we have to add a new scenario to our feature spec for creating comments. To fix the red spec we do:

* Create a partial in `views/tags/_form.html.erb`, which we render from both:
  * `views/tickets/_form.html.erb`
  * `views/comments/_form.html.erb`
* Define a `tag_names` virtual attribute in the `Comment` model too.
* Add this attribute to the list of permitted parameters in `CommentsController`.
* Add an `after_create` callback inside the `Comment` model, to the `associate_tags_with_ticket` method, and define the method itself.

### Restricting tag creation
In **Ticketee** we want to restrict the privilege of adding tags to **managers** of a project and **admins**, which thanks to the roles and authorization systems we have in place, it's gonna be a piece of cake to implement. This restriction is gonna be added to the `CommentsController`, naturally after a new context to the already existing `comments_controller_spec.rb`. As always we start **red**, but let's allow the failing spec to guide our steps:

* We are gonna create a new method called `sanitized_parameters` among the `private` methods of the `CommentsController`. The purpose of this method is to clean up the clutter in the `create` action.
* Next we define the `tag?` method in our `policies/ticket_policy.rb`. Optionally, we could add more specs to our `ticket_policy_spec.rb` to test the new method.

We should take care too of controlling **tagging** operations when a ticket is being created. Starting with a spec in our `tickets_controller_spec.rb` and upon failing we start implementing:

* Here we need to do the same we did for our comments controller, we have to sanitize the parameters passed to the `build` method inside the `create` action. This way the spec will pass.

Now we have to hide the tag field in the comments form for users that are not authorized to tag. That will break our `creating_tickets_spec.rb:91`. To fix it:
* Go to the `before` block of the spec and change the role assigned to `manager`, that will do.

That should be all regarding tagging restrictions.

### Deleting tags
To allow users delete tags, we're gonna add an "x" to each tag so when it's clicked the tag will disappear and using JavaScript we'll make an asynchronous request to the `destroy` action in the controller.

Spec'ing a feature should be the first step, and seeing how it fails at first the next one. The steps to turn it green are:

* First order or business is implementing the `tag` method used in the feature. This is a **Capybara finder** method used to locate a given html element using its class. We'll put it in `pec/support/ capybara_finders.rb`.
* Then, in the `_tag.html.erb` partial we have to create the link inside the tag that triggers the asynchronous request to the `remove` action in the `TagsController`(which doesn't exist yet). This link will only show to users able of creating tags. Adding a `remote: true` option makes the link make an asynchronous request once it's clicked.
* In order to make the link above work, we have to pass it a `@ticket` variable from the `tickets/show.html.erb` view.
* Next, we'll define a route to the `remove` action of the `TagsController`.
* And obviously we have to generate the `TagsController` itself, and inside it the `remove` action.
* Lastly, once we remove the tag from the ticket in the backend, we need to make disappear the tag element from the page. To do that we'll use a small CoffeeScript that will remove the tag only after a successful response from the asynchronous request.

That's all regarding the deleting tags feature.

### Searching tags
Another feature of **Ticketee** is finding tickets by tags. We start our work on this feature writing a spec that naturally fails at the beginning but that it will turn green after:

* Adding a search field in the `views/projects/show.html.erb` partial, as well as some styling in `responsive.scss`.
* Adding a route for the path `search_project_tickets_path` used in the partial. This route defines an endpoint to the `search` method in `TicketsController`.
* Defining the `search` method itself in `TicketsController`.
* Modify the `projects/show.html.erb` template. This will break the `show` action of the `ProjectsController`. Run `viewing_tickets_spec.rb` to see it. To fix it:
  * Define a `@tickets` variable inside the `show` action of `projects_controller.rb`(underneath the `authorize` call)
* Put a render call to the `projects/show.html.erb` template from the `search` action in `TicketsController`.
* Finally, add the [searcher][17] gem to the `Gemfile`, and use its `searcher` class method in the `Ticket` model.

The feature spec should be passing now. Remember to specify search queries using the syntax `tag:ticket`.

### Searching by state
In this section we implement a feature that allows us to search tickets by **state**, meaning tickets that are open, closed, etc. Before anything else, we write a spec for the feature, which at first will be red, but we'll turn it green following the next steps:

* Enabling searching on states in the `searcher` class method (inside the `Ticket` model). We just have to add: `label :state, from: :state, field: "name"` to the body of the method.

That should be enough for getting our spec to pass. Now we can query our `Ticket` model asking it for tickets with a given state, even using chained queries such as `tag:ticket state:open`.

### Searching by clicking tag link
The final feature in this chapter is about turning all tags into links so when a user clicks on them, she's shown only the tickets for that tag. We start adding a new scenario to the `searching_spec.rb` file. The steps for making it pass:

* Inside the `tags/_tag.html.erb` we need to wrap the tag names inside link tags.

And that should get the spec green.

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
[17]: https://github.com/radar/searcher
