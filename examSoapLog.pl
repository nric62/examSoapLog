use strict; 
use warnings; 
use feature qw /say/;

my $filename = 'soap.log'; 
open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open file '$filename' $!"; 
my ($cnt,$failureActions,$failureFault,$insideError,$cntMsg)=(0,0,0,0,0);
my $time="";
while ( (my $row = <$fh>) ) { 
		$cnt++;
		chomp $row; 
		if ($row =~ /\d{2}\/\d{2}\/\d{4}/) {$time=$row;	} #12/02/2015 15:14:00 *********************
		elsif ($row =~ /Input to Web service with SOAP action/) {	#Action
			$cntMsg++;
			my ($act)= (split("=",$row))[1];
			my @actions=split(",",$act);
			if ($#actions>0) {
				print "$cnt :: $time\n"; 
				print "$cnt :: ".$#actions." ::$row\n"; 
				$failureActions++;
				}
			
			}
		elsif ($row =~ /<error /) {$insideError=1;	 } #say "INSIDE $cnt";}#Insie error
		elsif ($row =~ /<\/error>/) {$insideError=0; } #say "OUTIDE $cnt";}#Fine Insie error
		elsif ($insideError==1) {	
				print "$cnt :: $time\n"; 
				print "$cnt :: <ERR> ::$row\n"; 
				$failureFault++;
			
			}
		
		
		}
say "Nr Msg=$cntMsg";
say "failure Action=$failureActions";
say "failure Fault=$failureFault";
