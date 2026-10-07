
#Noah Buist


use strict;
use Getopt::Long;

require "./C-level-functions.pl";
require "./B-level-functions.pl";

#  Variables to hold the results of the command line options
#  TODO:  Initialize these variables to the appropriate defaults
my $filename   = "";
my $datapoints = 0;
my $centers    = 0;
my $groups     = 1;
my $help       = 0;

#  TODO
#  Make a call to GetOptions to parse the command line arguments
#  based on the requirements described in the assignment specification
#  Store the results into the variables defined above

GetOptions(
    "filename=s"  => \$filename,
    "datapoints!" => \$datapoints,
    "centers!"    => \$centers,
    "groups!"     => \$groups,
    "help"        => \$help,    # no "!" so --nohelp is not allowed
) or do {
    printUsage();
    exit 1;
};

# TODO  Check if the --help option was specified.  If it was, call the
# subroutine printUsage and then exit with a status of 0

if ($help) {
    printUsage();
    exit 0;
}

#  TODO
#  Write a statement that verifies that a value has been provided for the
#  --filename command line argument, and that at least one of the
#  --datapoints, --centers, and --groups arguments have been specified
#  If not, the program should call printUsage and then exit with a status of 1

if ( $filename eq "" || !( $datapoints || $centers || $groups ) ) {
    printUsage();
    exit 1;
}

my $datafile;

unless ( open $datafile, $filename ) {
    print "Cannot open $filename";
    exit 2;
}

my @labels = readLabels($datafile);

my $line       = "";
my @datapoints = ();
chomp( my @lines = <$datafile> );

my @observations       = @lines[ 0 .. $#lines - 1 ];
my $datapointsArrayRef = readObservations( \@observations );

#  TODO-Copy the line from Kmeans-C.pl that sets the value of the variable @datapoints from $datapointsArrayRef
#  Then delete this comment

@datapoints = @{$datapointsArrayRef};

my $valid = 1;
my $error = "";
my $clusterCentersArrayRef;

( $valid, $error, $clusterCentersArrayRef ) =
  readAndValidateClusterCenters( $lines[-1], $datapointsArrayRef );

if ( !$valid ) {
    print "ERROR: $error\n";
    exit 3;
}

my $i = 1;
print "There were ", scalar @datapoints,
  " observations in the file, consisting of ", scalar @labels - 1,
  " features\n";

#  TODO  Make sure the data points are only displayed when the --datapoints argument
#  has been specified

for my $datapointRef (@datapoints) {
    printObservation( $i, $datapointRef );
    $i++;    
}

my @clusterCenters = ();

#  TODO-Copy the line from your C-level solution that assigns the array referenced by $clusterCentersArrayRef to the array variable @clusterCenters
#  Then delete this comment

@clusterCenters = @{$clusterCentersArrayRef};

#  TODO Make sure the text "Cluster centers" and the datapoints chosen as the
#  cluster centers are only displayed when the --centers argument has been specified

if ($centers) {
    print "\nCluster centers\n";
    for my $clusterCenterIndex (@clusterCenters) {
        printObservation( $clusterCenterIndex,
            $datapoints[$clusterCenterIndex] );
    }
}

#  TODO  Make sure the groups are printed only when the --groups argument is true
if ($groups) {
    my $groupsRef = createGroupsByLabel( \@datapoints );
    printGroups($groupsRef);
}

