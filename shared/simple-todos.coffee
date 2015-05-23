@Tasks = new Mongo.Collection('tasks')

Meteor.methods
  addTask: (text) ->
    # Make sure the user is logged in before inserting a task
    if !Meteor.userId()
      throw new (Meteor.Error)('not-authorized')
    Tasks.insert
      text: text
      createdAt: new Date
      owner: Meteor.userId()
      username: Meteor.user().username

  deleteTask: (taskId) ->
    task = Tasks.findOne(taskId)
    if task.private and task.owner != Meteor.userId()
      # If the task is private, make sure only the owner can delete it
      throw new (Meteor.Error)('not-authorized')
    else
      Tasks.remove taskId

  setChecked: (taskId, setChecked) ->
    task = Tasks.findOne(taskId)
    if task.private and task.owner != Meteor.userId()
      # If the task is private, make sure only the owner can delete it
      throw new (Meteor.Error)('not-authorized')
    else
      Tasks.update taskId, $set: checked: setChecked

  setPrivate: (taskId, setToPrivate) ->
    task = Tasks.findOne(taskId)

    # Make sure only the task owner can make a task private
    throw new Meteor.Error('not-authorized') if task.owner != Meteor.userId()

    Tasks.update taskId, $set: private: setToPrivate
