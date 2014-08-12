# Forces the use of the --write-catalog-summary switch when using puppet apply
puppet() {

    exec 1>&2

    if [[ $1 == "apply" ]]; then

        # Check if --write-catalog-summary switch has been used; Returns 0 if not
        echo "$@" | grep -vq -- "--write-catalog-summary"

        if [[ $? == 0 ]]; then
            echo "Applying --write-catalog-summary option by default"
            shift
            set -- apply --write-catalog-summary "$@"
        fi

    fi

    command puppet "$@"

}
