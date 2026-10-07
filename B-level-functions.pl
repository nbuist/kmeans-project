#  Noah Buist

#  This subroutine should print out the usage information shown in the assignment
#  description for the --help option.
sub printUsage () {
    print
"Usage: perl kmeans-B.pl --filename name [--datapoints=0] [--centers=0] [--groups=1] [--help]\n";
    print "At least one of --datapoints, --centers, --groups must be true\n";
}

#  This subroutine takes a reference to an array of observations, where an observation
#  is a reference to a hash containing keys "label" and "values".  The value of the "label"
#  key is a string identifying the observation's label, and the value of the "values" key
#  is a reference to an array.
#
#  The routine should return a reference to a hash whose keys are the distinct labels
#  for the observation, and whose values are references to the observations having
#  that label.
sub createGroupsByLabel {
    my ($observationsRef) = @_;
    my %groups;
    for my $observation (@$observationsRef) {
        push @{ $groups{ $observation->{"label"} } }, $observation;
    }
    return \%groups;
}

#  This routine takes a reference to an array of observations, and returns a reference
#  to an array whose components are the averages of the corresponding components for
#  the observations.
#
#  For example, if the "values" components of the observations contained the arrays
#  (1, 4, 7), (2, 5, 8), and (3, 6, 9), the returned array would contain
#  (1+2+3 = 6/3 = 2, 4+5+6 = 15/3 = 5, 7+8+9 = 24/3 = 8)
sub computeAverage {
    my ($observationsRef) = @_;
    my $n                 = scalar @$observationsRef;
    my $features          = scalar @{ $observationsRef->[0]{"values"} };

    my @averages;
    for my $f ( 0 .. $features - 1 ) {
        my $sum = 0;
        $sum += $_->{"values"}[$f] for @$observationsRef;
        push @averages, $sum / $n;
    }
    return \@averages;
}

#  This subroutine takes a reference to the hash produced by createGroupsByLabel
#  and prints out the information contained in that hash based on the specifications
#  in the assignment description.  Use the printObservation subroutine
#  to print out each observation, and the computeAverage subroutine to compute the
#  average of each group of observations.
sub printGroups {
    my ($groupsRef) = @_;
    print "Groups\n";

    my @labels = sort keys %$groupsRef;
    for my $i ( 0 .. $#labels ) {
        my $label = $labels[$i];
        my $group = $groupsRef->{$label};

        print "\n" if $i > 0;    # blank line between groups

        print "$label (", scalar @$group, ")\n";
        my $j = 1;
        for my $observation (@$group) {
            printObservation( $j, $observation );
            $j++;
        }

        my $averages = computeAverage($group);
        print "Avg.\t(", join( ", ", @$averages ), ")\n";
    }
}

#  This line indicates the return status of "requiring" the file.  It should always be
#  a true value; don't modify or delete this line
1;
