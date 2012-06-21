#!/usr/bin/perl
use Switch;

my %outputs;

#Score of each letter. Found raw data on http://www.xwordinfo.com/Scrabble.aspx
my %value = (
	'a' => 1,
	'b' => 3,
	'c' => 3,
	'd' => 2,
	'e' => 1,
	'f' => 4,
	'g' => 2,
	'h' => 4,
	'i' => 1,
	'j' => 8,
	'k' => 5,
	'l' => 1,
	'm' => 3,
	'n' => 1,
	'o' => 1,
	'p' => 3,
	'q' => 10,
	'r' => 1,
	's' => 1,
	't' => 1,
	'u' => 1,
	'v' => 4,
	'w' => 4,
	'x' => 8,
	'y' => 4,
	'z' => 10,
	' ' => 0
);

print(calculate_score($ARGV[0])."\n");
#Calculate score of the given string.
#This can be a bare undercase string of just your word, or it can contain
#uppercase prefix characters that modify the score.
#i.e. calculate_score("calDculate") means the second C is to be double-lettered.#D = double letter
#E = double word
#T = triple letter
#U = triple word
#(A space represents the blank tile.)
sub calculate_score{
my $word = shift;
my $double_letter = 0;
my $double_word = 0;
my $triple_letter = 0;
my $triple_word = 0;
my $score = 0;
foreach $char (split //, $word){
	switch($char){
		case 'D' {$double_letter = 1;}
		case 'E' {$double_word += 1;}
		case 'T' {$triple_letter = 1;}
		case 'U' {$triple_word += 1;} 
		else { 
			if($double_letter){
				$score+=2*($value{$char});
				$double_letter=0;
			}
			elsif($triple_letter){
				$score+=3*($value{$char});
				$triple_letter=0;
			}
			else{#Just a normal [a-z ] character
				$score+=$value{$char};
			}
		}
	}
}
if($double_word){
	$score *= 2*$double_word;
}
if($triple_word){
	$score *= 2*$triple_word;
}
return $score;
}

sub read_dictionary{
    my $filename = shift;
    open(DICT, "<$filename");
    while(<DICT>){
	 my $line = $_;
	 chomp($line);
	 my $score = calculate_score($line);
	 #print "$line $score\n";
	 push @{$outputs{$score} }, $line;
    }
}

sub write_output{
    for my $key (keys %outputs){
	my $filename = "$key"."_point_words.txt";
	print "Writing out to $filename...";
	open(OUTFILE,">$filename") or die "Can't open file";
	for $i (0 .. $#{ $outputs{$key} }){
	    print OUTFILE "$outputs{$key}[$i]\n";
	}
	close OUTFILE;
    }
}
