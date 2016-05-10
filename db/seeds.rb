# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
todo1 = Todo.create({title: "First todo"})
todo2 = Todo.create({title: "Next todo"})

tag1 = Tag.create({name: "Chores"})
tag2 = Tag.create({name: "This weekend"})

Tagging.create({todo: todo1, tag: tag1})
Tagging.create({todo: todo2, tag: tag2})
