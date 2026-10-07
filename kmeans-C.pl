#Noah Buist

use strict;

require "./C-level-functions.pl";

if ( @ARGV != 1 ) {
    print "Usage: perl kmeans.pl datafile";
    exit 1;
}

my $filename = $ARGV[0];
my $datafile;

unless ( open $datafile, $filename ) {
    print "ERROR: Cannot open $filename\n";
    exit 2;
}

my @labels = readLabels($datafile);

my $line       = "";
my @datapoints = ();
chomp( my @lines = <$datafile> );

my @observations = @lines[0 .. $#lines-1];
my $datapointsArrayRef = readObservations (\@observations);

#  TODO Write a statement below this one that assigns the array referenced by $datapointsArrayRef to the 
#  array variable @datapoints

my $valid = 1;
my $error = "";
my $clusterCentersArrayRef;

( $valid, $error, $clusterCentersArrayRef) = readAndValidateClusterCenters($lines[-1], $datapointsArrayRef);
unless ($valid) {
    print "ERROR: $error\n";
    exit 3;
}

my @clusterCenters = ();

@datapoints = @{$datapointsArrayRef};
@clusterCenters = @{$clusterCentersArrayRef};

#  TODO Write a statement below this one that assigns the array referenced by $clusterCentersArrayRef to the 
#  array variable @clusterCenters


print "There were ", scalar @datapoints,
  " observations in the file, consisting of ", scalar @labels - 1,
  " features\n";

my $i = 1;

for my $datapointRef (@datapoints) {
    printObservation( $i, $datapointRef );
    $i++;
}

print "\nCluster centers\n";
for my $clusterCenterIndex (@clusterCenters) {
    printObservation( $clusterCenterIndex, $datapoints[$clusterCenterIndex] );
}
