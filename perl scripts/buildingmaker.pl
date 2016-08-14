use Modern::Perl;
use File::Copy;
use Math::Round;
#Building Setup

my @envrtypes = qw(sustainable extractive na);
my @wagetypes = qw(high_wage low_wage na);
my @buildtypes = qw(overbuilt underbuilt na);
my $levels = 10;
# Constants used to calculate values for all buildings
my $cost2outK = 120;
my $sciup2outK = 0.25;
my $time2costK = 2;
my $startoutput = 1;
my $outperK = 1;
my $increment = 0.25;

# Etype Coefficicents
my @etypecostX = (1, 1, 1);
my @etypeoutX = (1-$increment, 1+$increment, 1); 
my @etypeupX = (1, 1, 1);

#Wtype Coeff
my @wtypecostX = (1, 1, 1);
my @wtypeoutX = (1, 1, 1);
my @wtypeupX = (1, 1, 1);

#Btype Coeff
my @btypecostX = (1+$increment, 1-$increment, 1);
my @btypeoutX = (1+$increment, 1-$increment, 1);
my @btypeupX = (1+$increment, 1-$increment, 1);
my @btypecost2outX = (1+$increment, 1-$increment, 1);

my %techprereq = (
	standard_mine => "vicar_mining",
	supercharged_mine => "vicar_high_out_mines",
	unsafe_mine => "vicar_cost_eff_mines",
	comfortable_mine => "vicar_work_friendly_mine",
);

#icon directory
my $iconsrc = 'C:\Program Files (x86)\Steam\SteamApps\common\Stellaris\gfx\interface\icons\buildings';
my $icondest = 'E:\Users\Soren\Documents\Paradox Interactive\Stellaris\mod\AATEST\gfx\interface\icons\buildings';

#my $outdh = 'E:\Users\Soren\Documents\Paradox Interactive\Stellaris\mod\AATEST\common\buildings';
#open my $out, '>', 'C:\Program Files (x86)\Steam\SteamApps\common\Victoria 2\mod\Separatism\events\SepartismInitialization.txt' or die $!;

#Start counting
my $enum = 0;



foreach my $etype (@envrtypes){	
	my $ecostX = $etypecostX[$enum];
	my $eoutX = $etypeoutX[$enum];
	my $eupX = $etypeupX[$enum];
	my $wnum = 0;
	foreach my $wtype (@wagetypes){
		my $wcostX = $wtypecostX[$wnum];
		my $woutX = $wtypeoutX[$wnum];
		my $wupX = $wtypeupX[$wnum];
		my $bnum = 0;
		foreach my $btype (@buildtypes){	
			my $bcostX = $btypecostX[$bnum];
			my $boutX = $btypeoutX[$bnum];
			my $bupX = $btypeupX[$bnum];
			my $bcost2outX = $btypecost2outX[$bnum];
			my $building_name = "building\_$etype\_$wtype\_$btype\_mine";
			#say $building_name;
				foreach my $level (1..10){
					my $building = "$building_name\_$level";
					my $levelplus = $level + 1;
					#say "$wcostX $woutX $wupX $bcostX $boutX $bupX $bcost2outX";
					my $produces = nearest(0.1, $startoutput + ($level * $outperK * $eoutX * $woutX * $boutX));
					my $mcost = nearest(0.1, $produces * $ecostX * $wcostX * $bcostX * $cost2outK * $bcost2outX);
					my $buildtime = int($mcost * $time2costK);
					my $scicost = nearest(0.01, ($produces * $sciup2outK * $eupX * $wupX * $bupX) - 0.25);
					print "$building \= \{ \n";
					print "\t base_buildtime \= $buildtime \n";
					print "\t cost \= \{\n\t\t minerals \= $mcost\n\t\}\n";
					print "\t required_resources \= \{\n\t\t engineering_research \= $scicost\n\t\}\n";
					print "\t produced_resources \= \{\n\t\t minerals \= $produces\n\t\}\n";
					if ($building_name eq "building_na_na_na_mine") {
						 print "\t upgrades \= \{\n\t\t $building_name\_$levelplus \n\t\}\n" } else {
							 print "\t upgrades \= \{\n\t\t $building_name\_$levelplus \n\t\t building\_na\_na\_na\_mine\_$level \n\t\t building\_na\_na\_na\_mine\_$levelplus \n\t\}\n";
					};
					print "\tprerequisites \= \{ \n\t\t tech\_mining\_$level \n\t \} \n";
					#Begin Allow Section
					print "\t allow \= \{";
					#Require appropriate Technology
					if ($enum != 2){
						print "\n\t\t has_technology \= tech\_$etype\_$level ";
					};
					if ($wnum != 2){
						print "\n\t\t has_technology \= tech\_$wtype\_$level ";
					};
					if ($bnum != 2){
						print "\n\t\t has_technology \= tech\_$btype\_$level ";
					};
					# Disallow building on uninhabitable planets
					print " \n\t\t planet \= \{\n\t\t\t NOT \= \{ \n\t\t\t\t OR \= \{" ;
					print "\n\t\t\t\t\t is\_planet\_class \= pc\_gas\_giant \n\t\t\t\t\t is\_planet\_class \= pc\_asteroid";
					print "\n\t\t\t\t\t is\_planet\_class \= pc\_molten \n\t\t\t\t\t is\_planet\_class \= pc\_barren";
					print "\n\t\t\t\t\t is\_planet\_class \= pc\_barren\_cold \n\t\t\t\t\t is\_planet\_class \= pc\_toxic";
					print "\n\t\t\t\t\t is\_planet\_class \= pc\_fozen";
					print "\n\t\t\t\t\} \n\t\t\t\} \n\t\t\} \n\t\}";
					#if ($enum = 2){print "/n" }else {
						
					print "\n}\n\n\n";
					copy("$iconsrc\\building\_basic\_mine\.dds","$icondest\\$building\.dds");
				};
			$bnum++;
		};
		$wnum++;
	};
	$enum++
}; 

