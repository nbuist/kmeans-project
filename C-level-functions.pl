#Noah Buist


#  This subroutine is passed a file handle representing an already 
#  opened file containing the data to be processed.  It should
#  - Read and chomp the first line from the file
#  - Delete any " characters from the line  (see the /d argument to the tr function)
#  - Split the line using a comma as the delimiter
#  - return the resulting array
sub readLabels {
    my ($fh) = @_;
    my $line = <$fh>;
    chomp ($line);
    $line =~ tr/"//d;
    return split(/,/, $line);
}


#  This subroutine is passed one argument:
#  a reference to an array of strings from the input file, with each line 
#  being a single observation from the data set.  The line is a comma-separated
#  sequence of values.  The first n-1 values are measurements of some feature 
#  of the observation, while the last value is a label indicating the observation's
#  class.
#  The subroutine should return a reference to an array whose elements are 
#  references to hashes containing two keys:  "label" and "values".  The 
#  value for the "label" key is simply the last value on the line,
#  with any "" characters around the label having been removed
#  The value for the "values" key is a reference to an array containing the n-1
#  measurements
sub readObservations {
    my ($ref) = @_;
    my @results = ();
    for my $line (@{$ref}) {
        my @fields = split(/,/, $line);
        my $label = pop @fields;
        $label =~ tr/"//d;
        push @results, { label => $label, values => \@fields };
    }
    return \@results;
}

#  This subroutine is passed two arguments.
#  The first is a scalar reprenting an observation number
#  The second is a reference to a hash containing the keys
#  label and values.  The values of these keys is described in the 
#  documentation for the readObservations function above.
#  The function should print out the following information, all on 
#  a single line, with a new line character at the end
#  - the observation number
#  - a tab
#  - the label for the observation
#  - a space
#  - the values for the observation, in the format (x1, x2, ..., xn)
#  Note there is a space after each of the commas
#  A sample observation might look like this:
#  1       Setosa:(5.1, 3.5, 1.4, .2)
sub printObservation {
    my ($num, $obs) = @_;
    my $valuesString = join(", ", @{$obs->{values}});
    print "$num\t$obs->{label}:($valuesString)\n";
}


#  This subroutine is passed 2 arguments:
#  A string containing the last line of the data file
#  A reference to the array of data points.
#
#  It should return a list containing 3 elements
#  Element 0:  a "boolean" indicating whether the cluster centers are valid
#  Element 1:  a string describing the reason the cluster centers are invalid, or 
#              the empty string if the centers were valid
#  Element 2:  a reference to an array containing the cluster center index values; this is a reference
#              to an empty array if an error condition is flagged
#
#  A cluster center index is invalid if 
#  -  it is less than 0 or greater than the largest valid index for the array referenced by the 2nd argument
#     In this case the error message should be in the form 
#     "Cluster center # is invalid; must be between 0 and #"
#
#  The function should also return false if a data point index is included in the list of cluster centers 
#  more than once.  In this case the error message should be in the form
#  Index # specified multiple times as a cluster center
sub readAndValidateClusterCenters {
    #  You should replace this line of code with your implementation
    my ($line, $dataRef) = @_;
    my @index = split(/,/, $line);
    my @centers = ();
    my %seen;
    my $max = $#{$dataRef};
    foreach my $i (@index){
        if ( $i < 0 || $i > $max ) {
            return (0, "Cluster center $i is invalid; must be between 0 and $max", []);
        }
        if ( $seen{$i} ) {
            return (0, "Index $i specified multiple times as a cluster center", []);
        }
        $seen{$i} = 1;
        push @centers, $i;
    }
    return (1, "", \@centers);
}

#  This line indicates the return status of "requiring" the file.  It should always be
#  a true value; don't modify or delete this line
1;
