require './requirements'

jim = Record.new(:jim => {name: "Jim", age: 12})
bob = Record.new(:bob => {name: "Bob", age: 13})
jekyll = Record.new(:jekyll => {name: "Jekyll"})
heidi = Record.new(:heidi => {name: "Heidi"})
hubble = Record.new(:hubble => {name: "Hubble"})

people = Table.new(:people)
pets = Table.new(:pets)

people