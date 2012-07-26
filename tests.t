Load the library.

  $ source "$TESTDIR/tables.sh"

Create a new table.

  $ t.new name gender planet
  $ myt="$(t.ref)"

Confirm zero-length.

  $ t.len $myt
  0

Add a couple of items.

  $ t.add $myt shrikant male earth

Check the length is one.

  $ t.len $myt
  1

Get the first item's name.

  $ t.get $myt 1 name
  shrikant
