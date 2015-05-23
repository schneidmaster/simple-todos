Meteor.subscribe('tasks')

Template.body.helpers
  tasks: ->
    if Session.get('hideCompleted')
      # If hide completed is checked, filter tasks
      Tasks.find { checked: $ne: true }, sort: createdAt: -1
    else
      # Otherwise, return all of the tasks
      Tasks.find {}, sort: createdAt: -1
  hideCompleted: ->
    Session.get 'hideCompleted'
  incompleteCount: ->
    Tasks.find({checked: {$ne: true}}).count()

Template.body.events 
  'submit .new-task': (event) ->
    # This function is called when the new task form is submitted
    text = event.target.text.value
    Meteor.call('addTask', text)
    # Clear form
    event.target.text.value = ''
    # Prevent default form submit
    false
  'change .hide-completed input': (event) ->
    Session.set('hideCompleted', event.target.checked)

Template.task.helpers 
  isOwner: ->
    @owner == Meteor.userId()

Template.task.events
  'click .toggle-checked': ->
    # Set the checked property to the opposite of its current value
    Meteor.call('setChecked', @_id, ! @checked);
  'click .toggle-private': ->
    Meteor.call('setPrivate', @_id, ! @private);
  'click .delete': ->
    Meteor.call('deleteTask', @_id);

Accounts.ui.config
  passwordSignupFields:
    'USERNAME_ONLY'