#!/bin/zsh

# TODO: Validate input before doing anything, in all functions.

export __TABLE_INDEX=0

t.new () {
    # Creates a new table abstraction. Each table is internally stored as an
    # array. The metadata of the table is also stored in the same array. The
    # first item given the no. of fields, followed by the names of these field.
    # So, for each table's array, (no. of fields + 1) items at the start of this
    # array are metadata.

    # Get ourselves a new index for this table.
    export __TABLE_INDEX=$(($__TABLE_INDEX + 1))
    local ref=$__TABLE_INDEX

    # Create a new array to hold this table.
    eval "__TABLE_DATA_$ref=($#)"

    # Add the field names to the array.
    while [[ ! -z $1 ]]; do
        eval "__TABLE_DATA_$ref=(\$__TABLE_DATA_$ref $1)"
        shift
    done

}

t.ref () {
    # Echo a reference (index) to the last created table.
    echo $__TABLE_INDEX
}

t.len () {
    # Given the reference to a table, echo the length of the table. That is, the
    # no. of *rows* of data in the table.

    local ref="$1"

    local total_len="$(eval "echo \${#__TABLE_DATA_$ref}")"

    # TODO: Move this to a function.
    local field_count="$(eval "echo \$__TABLE_DATA_${ref}[1]")"

    echo "$(eval "echo \"$((
            ($total_len - $field_count - 1) / $field_count
            ))\"")"

}

t.add () {
    # Given a reference to a table, and a few more arguments (equal to the no.
    # of fields in the table), this function adds the given values as a row to
    # the given table. Length of the table increases by `1` after this
    # operation.

    # Get the reference to the table.
    local ref="$1"
    shift

    while [[ ! -z $1 ]]; do
        eval "__TABLE_DATA_$ref=(\$__TABLE_DATA_$ref $1)"
        shift
    done
}

t.get () {
    # Given a reference to a table, a row index (1-based) and a field name, this
    # function echoes out the value of that field at the given row, in the given
    # table.

    # Get the table reference, the row number and the field name.
    local ref="$1"
    local row="$2"
    local field="$3"

    # Find which field is requested.
    local i=2
    local field_count="$(eval "echo \$__TABLE_DATA_${ref}[1]")"
    local fields_end_index="$((field_count + 4))"

    while [[ $i -le $fields_end_index ]]; do
        if eval "test '\$__TABLE_DATA_${ref}[$i]' '==' '$field'" ; then
            break
        fi
        i=$((i + 1))
    done

    # Get the final index of the required value in the array.
    local index=$((1 + field_count + ((row - 1) * field_count) + 1))

    # Echo the value at that index.
    echo "$(eval "echo \$__TABLE_DATA_${ref}[$index]")"
}
