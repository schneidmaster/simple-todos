Meteor.startup ->
  # code to run on server at startup

Meteor.publish 'tasks', ->
  Tasks.find $or: [
    { private: $ne: true }
    { owner: @userId }
  ]