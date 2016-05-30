# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
todo1 = Todo.create({title: "Do the dishes"})
todo2 = Todo.create({title: "Organize camping gear"})
todo3 = Todo.create({title: "Go for a hike"})
todo4 = Todo.create({title: "Untagged todo"})

tag1 = Tag.create({name: "Chores"})
tag2 = Tag.create({name: "This weekend"})

Tagging.create({todo: todo1, tag: tag1})
Tagging.create({todo: todo2, tag: tag1})
Tagging.create({todo: todo2, tag: tag2})
Tagging.create({todo: todo3, tag: tag2})
