use Modern::Perl;
use File::Copy;

#Building Setup

my @names = qw(standard_mine supercharged_mine unsafe_mine comfortable_mine);
my $levels = 10;
# Constants used to calculate values for all buildings
my $cost2outK = 30;
my $up2outK = 0.25;
my $time2costK = 2;
my $startoutput = 1;
my $outperK = 1;
# Array of values of each building type 
my @btimeper = (1, 1.25, 0.8, 1.25);
my @mcostper = (1, 1.25, 0.8, 1.25);
my @ecostper = (1, 1.25, 0.8, 1.25);
my @scostper = (0.5, 0.6, 0.4, 0.6);
my @outper = (1, 1.25, 1, 1);
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

for my $name (0){
	my $bname = $names[$name];
	foreach my $level (1..10){
		my $levelplus = $level + 1;
		my $produces = $startoutput + ($level * $outperK * $outper[$name]);
		my $building = "building\_$bname\_$level";
		my $mcost = $produces * $mcostper[$name] * $cost2outK;
		my $buildtime = $mcost * $time2costK;
		my $ecost = $produces * $up2outK * $ecostper[$name];
		my $scost = ($produces * $up2outK * $scostper[$name]) - 0.25;
		print "$building \= \{ \n";
		print "\t base_buildtime \= $buildtime \n";
		print "\t cost \= \{\n\t\t minerals \= $mcost\n\t\}\n";
		print "\t required_resources \= \{\n\t\t energy \= $ecost\n";
		print "\t\t engineering_research = $scost \n\t\}\n";
		print "\t produced_resources \= \{\n\t\t minerals \= $produces\n\t\}\n";
		print "\t upgrades \= \{\n\t\t building\_$names[1]\_$level \n\t\t building\_$names[2]\_$level \n\t\t building\_$names[3]\_$level \n\t\t building\_standard\_mine\_$levelplus \n\t\}\n";
		print "\t prerequisites \= \{\n\t\t \"tech\_$techprereq{$bname}\_$level\"\n\t\}\n";
		print "}\n\n\n";
		copy("$iconsrc\\building\_basic\_mine\.dds","$icondest\\building\_$bname\_$level\.dds");
		};
	};

foreach my $name (1..3){
	my $bname = $names[$name];
	foreach my $level (1..10){
		my $levelplus = $level + 1;
		my $produces = $startoutput + ($level * $outperK * $outper[$name]);
		my $building = "building\_$bname\_$level";
		my $mcost = $produces * $mcostper[$name] * $cost2outK;
		my $buildtime = $mcost * $time2costK;
		my $ecost = $produces * $up2outK * $ecostper[$name];
		my $scost = ($produces * $up2outK * $scostper[$name]) - 0.25;
		print "$building \= \{ \n";
		print "\t base_buildtime \= $buildtime \n";
		print "\t cost \= \{\n\t\t minerals \= $mcost\n\t\}\n";
		print "\t required_resources \= \{\n\t\t energy \= $ecost\n";
		print "\t\t engineering_research = $scost \n\t\}\n";
		print "\t produced_resources \= \{\n\t\t minerals \= $produces\n\t\}\n";
		print "\t upgrades \= \{\n\t\t building\_$bname\_$levelplus \n\t\t building\_standard\_mine\_$level \n\t\t building\_standard\_mine\_$levelplus \n\t\}\n";
		print "\t prerequisites \= \{\n\t\t \"tech\_$techprereq{$bname}\_$level\"\n\t\}\n";
		print "}\n\n\n";
		copy("$iconsrc\\building\_basic\_mine\.dds","$icondest\\building\_$bname\_$level\.dds");
		};
	};