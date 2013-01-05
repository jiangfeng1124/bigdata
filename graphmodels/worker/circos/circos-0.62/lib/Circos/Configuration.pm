package Circos::Configuration;

=pod

=head1 NAME

Circos::Configuration - Configuration handling for Circos

=head1 SYNOPSIS

This module is not meant to be used directly.

=head1 DESCRIPTION

Circos is an application for the generation of publication-quality,
circularly composited renditions of genomic data and related
annotations.

Circos is particularly suited for visualizing alignments, conservation
and intra and inter-chromosomal relationships. However, Circos can be
used to plot any kind of 2D data in a circular layout - its use is not
limited to genomics. Circos' use of lines to relate position pairs
(ribbons add a thickness parameter to each end) is effective to
display relationships between objects or positions on one or more
scales.

All documentation is in the form of tutorials at L<http://www.circos.ca>.

=cut

# -------------------------------------------------------------------

use strict;
use warnings;

use base 'Exporter';
our @EXPORT_OK = qw(%CONF $DIMS);
our @EXPORT    = qw(
										 fetch_configuration
										 fetch_conf
										 get_counter
										 exists_counter
										 %CONF
										 $DIMS
									);

use Carp qw( carp confess croak );
use Config::General 2.50;
use Clone;
use File::Basename;
use File::Spec::Functions;
use Data::Dumper;
use Math::VecStat qw(sum min max average);
use Math::Round qw(round);
use FindBin;
use IO::File;
use Params::Validate qw(:all);
use List::MoreUtils qw(uniq);

use lib "$FindBin::RealBin";
use lib "$FindBin::RealBin/../lib";
use lib "$FindBin::RealBin/lib";

use Circos::Constants;
use Circos::Debug;
use Circos::Utils;
use Circos::Error;

our %CONF;
our $DIMS;

# -------------------------------------------------------------------
sub get_counter {
	my $counter = shift;
	confess if ! defined $counter;
	if (! exists_counter($counter)) {
		fatal_error("configuration","no_counter",$counter);
	} else {
		return $CONF{counter}{$counter};
	}
}

# -------------------------------------------------------------------
sub exists_counter {
	my $counter = shift;
	return defined $CONF{counter}{$counter};
}

# -------------------------------------------------------------------
sub increment_counter {
  my ($counter,$value) = @_;
  init_counter($counter,0);
	if (defined $value) {
		$CONF{counter}{$counter} += $value;
		printdebug_group("counter","incrementing counter",$counter,$value,"now",get_counter($counter));
	}
}

sub set_counter {
  my ($counter,$value) = @_;
	if (defined $value) {
		$CONF{counter}{$counter} = $value;
		printdebug_group("counter","set counter",$counter,$value,"now",get_counter($counter));
	}
}

{
	my %seen;
	sub init_counter {
		my ($counter,$value) = @_;
		if (! $seen{$counter}++) {
			if (defined $value) {
				$CONF{counter}{$counter} = $value;
			}
		}
		printdebug_group("counter","init counter",$counter,"with value",$value,"new value",get_counter($counter));
	}
}

# -------------------------------------------------------------------
# Return the configuration hash leaf for a parameter path.
#
# fetch_configuration("ideogram","spacing")
#
# returns
#
# $CONF{ideogram}{spacing}
#
# If the leaf, or any of its parents, do not exist, undef is returned.
sub fetch_configuration {
	my @config_path = @_;
	my $conf_item   = \%CONF;
	for my $path_element (@config_path) {
		if (! exists $conf_item->{$path_element}) {
	    return undef;
		} else {
	    $conf_item = $conf_item->{$path_element};
		}
	}
	return $conf_item;
}

sub fetch_conf {
	return fetch_configuration(@_);
}

# -------------------------------------------------------------------
# 
#
#
#
sub fetch_parameter_list_item {
	my ($list,$item,$delim) = @_;
	my $parameter_hash = make_parameter_list_hash($list,$delim);
	return $parameter_hash->{$item};
}

# -------------------------------------------------------------------
# Given a string that contains a list, like
#
# hs1:0.5;hs2:0.25;hs3:0.10;...
#
# returns a hash keyed by the first field before the delimiter with
# the second field as value.
#
# { hs1=>0.5, hs2=>0.25, hs3=>0.10, ... }
#
# The delimiter can be set as an optional second field. By default,
# the delimiter is \s*[;,]\s*
#
sub make_parameter_list_hash {
	my ($list_str,$record_delim,$field_delim) = @_;
	$record_delim ||= fetch_configuration("list_record_delim") || qr/\s*[;,]\s*/;
	$field_delim  ||= fetch_configuration("list_field_delim")  || qr/\s*[:=]\s*/;
	my $parameter_hash;
	for my $pair_str (split($record_delim,$list_str)) {
		my ($parameter,$value) = split($field_delim,$pair_str);
		if (exists $parameter_hash->{$parameter}) {
	    fatal_error("configuration","multiple_defn_in_list",$list_str,$parameter);
		} else {
	    $parameter_hash->{$parameter} = $value;
		}
	}
	return $parameter_hash;
}

# -------------------------------------------------------------------
# Given a string that contains a list, like
#
# file1,file2,...
#
# returns an array of these strings.
#
# [ "file1", "file2", ... ]
#
# The delimiter can be set as an optional second field. By default,
# the delimiter is \s*[;,]\s*
#
sub make_parameter_list_array {
	my ($list_str,$record_delim) = @_;
	$record_delim ||= fetch_configuration("list_record_delim") || qr/\s*[;,]\s*/;
	my $parameter_array;
	for my $str (split($record_delim,$list_str)) {
		push @$parameter_array, $str;
	}
	return $parameter_array;
}

# -------------------------------------------------------------------
# Parse a variable/value assignment.
sub parse_var_value {
	my $str = shift;
	my $delim = fetch_configuration("list_field_delim") || qr/\s*=\s*/;
	my ($var,$value) = $str =~ /(.+)?$delim(.+)/;
	if(! defined $var || ! defined $value) {
		fatal_error("configuration","bad_var_value",$str,$delim);
	} else {
		return ($var,$value);
	}
}

# -------------------------------------------------------------------
sub populateconfiguration {

  my %OPT = @_;
	
  for my $key ( keys %OPT ) {
		if (defined $OPT{$key}) {
			if ($key eq "debug_group") {
	      $CONF{$key} .= ",".$OPT{$key};
			} else {
	      $CONF{$key} = $OPT{$key};
			}
		}
  }

	# Combine top level hashes. This allows overriding values in blocks
	# that are included.
	#
	# <<include ideogram.conf>>
	# <ideogram>
	# label_size* = 12
	# </ideogram>
	
	merge_top_hashes( \%CONF );
	
	# Fields like conf(key1,key2,...) are replaced by $CONF{key1}{key2}
  #
  # If you want to perform arithmetic, you'll need to use eval()
  #
  # eval(2*conf(image,radius))
  #
  # The configuration can therefore depend on itself. For example, if
  #
  # flag = 10
  #
  # note = eval(2*conf(flag))

  resolve_synonyms( \%CONF, [] );
  repopulateconfiguration( \%CONF );
  override_values( \%CONF );
  check_multivalues( \%CONF, undef );

	fatal_error("configuration","no_housekeeping") if ! $CONF{housekeeping};

  # populate some defaults
  $CONF{'anglestep'}    ||= 1;
  $CONF{'minslicestep'} ||= 5;

}

sub resolve_synonyms {
	my $root = shift;
	my $tree = shift;
	if (ref $root eq "HASH") {
		for my $key (keys %$root) {
	    my $value = $root->{$key};
	    if (ref $value eq "HASH" ) {
				resolve_synonyms($value, [ @$tree, $key ]);
	    } elsif (ref $value eq "ARRAY") {
				map { resolve_synonyms($_, [ @$tree, $key ]) } @$value;
	    } else {
				my ($new_key,$action) = apply_synonym($value,$key,$tree);
				if (defined $new_key) {
					if ($action eq "copy") {
						$root->{$new_key} = $root->{$key};
					} else {
						$root->{$new_key} = $root->{$key};
						delete $root->{$key};
					}
				}
	    }
		}
	}
}

sub apply_synonym {
	my ($value,$key,$tree) = @_;
	my @synonyms = (
									{
									 key_rx => ".*::label_tangential", new_key => "label_parallel", action => "copy" },
								 );
    
	my $key_name  = join(":",@$tree)."::".$key;
	my ($new_key,$action);
	for my $s (@synonyms) {
		printdebug_group("conf","testing synonym",$s->{key_rx},$key_name);
		if ($key_name =~ /$s->{key_rx}/) {
	    $new_key = $s->{new_key};
	    $action  = $s->{action};
	    printdebug_group("conf","applying synonym",$action,$key_name,$new_key);
	    return ($new_key,$action);
		}
	}
	return;
}

# -------------------------------------------------------------------
# Parameters with *, **, ***, etc suffixes override those with
# fewer "*";
sub override_values {
	my $root = shift;
	my $parameter_missing_ok = 1;
	if (ref $root eq "HASH") {
		my @keys = keys %$root;
		# do we have any parameters to override?
		my @lengths = uniq ( map { length($_) } ( map { $_ =~ /([*]+)$/ } @keys ) );
		for my $len (sort {$a <=> $b} @lengths) {
	    for my $key (@keys) {
				my $rx = qr/^(.+)[*]{$len}$/;
				#printinfo("rx",$rx,"key",$key);
				if ($key =~ $rx) {
					my $key_name = $1;
					# do not require that the parameter be present to override it
					if ($parameter_missing_ok || grep($_ eq $key_name, @keys)) {
						#printinfo("overriding",$key_name,$root->{$key_name},$key,$root->{$key});
						$root->{$key_name} = $root->{$key};
					}
				}
	    }
		}
		for my $key (keys %$root) {
			my $value = $root->{$key};
	    if (ref $value eq "HASH" ) {
				#printinfo("iter",$key);
				override_values($value);
	    }
		}
	}
}

sub merge_top_hashes {
	my $root = shift;
	my @ok = qw(ideogram colors fonts patterns image plots links highlights);
	for my $key (keys %$root) {
		my $value = $root->{$key};
		if (ref $value eq "ARRAY" && is_in_list($key,@ok)) {
			printdebug_group("conf","merging top level block [$key]");
			$root->{$key} = clone_merge(@$value);
		}
	}
}

# -------------------------------------------------------------------
# multiple parameters are allowed if
# parent block name must match 'pass' regular expression
# parent block name must fail 'fail' regular expression
{
	my $ok = {
						flow       => { pass => qr/rule/ },
						condition  => { pass => qr/rule/ },
						radius     => { pass => qr/tick/ },
						axis       => { pass => qr/axes/ },
					 };
	
	sub check_multivalues {
		my ($root,$root_name,$level) = @_;
		
		return unless ref $root eq "HASH";
		$level ||= 0;
		
		my @keys = keys %$root;
		for my $key (@keys) {
	    my $value = $root->{$key};
	    my $pass;
	    if (ref $value eq "ARRAY") {
				if ($root_name eq $key."s") {
					# parent block is plural of this block (e.g. backgrounds > background)
					$pass = 1;
				}
				if (my $passrx = $ok->{$key}{pass} ) {
					$pass = $root_name =~ /$passrx/i;
				}
				if (my $failrx = $ok->{$key}{fail} ) {
					$pass = $root_name !~ /$failrx/i;
				}
				if (! $pass) {
					printdumper($root);
					fatal_error("configuration","multivalue",$key);
				}
			} elsif (ref $value eq "HASH") {
				# this is a block
	    }
			#printinfo($level,$key,$value);
		}
		
		for my $key (keys %$root) {
	    my $value = $root->{$key};
	    if (ref $value eq "HASH" ) {
				check_multivalues($value,$key,$level+1);
	    } elsif (ref $value eq "ARRAY") {
				map { check_multivalues($_,$key,$level+1) } @$value;
	    }
		}
	}
}

sub set_counters {
	my ($node,@paramfn) = @_;
	my %set_counter_names;
	for my $paramfn (@paramfn) {
		my ($param,$fn) = @{$paramfn}{qw(param fn)};
		if (my $value = $node->{$param}) {
	    for my $counter_txt (split(",",$value)) {
				my ($counter,$incr) = split(":",$counter_txt);
				$fn->($counter,$incr);
				$set_counter_names{$counter}++;
	    }
		}	
	}
	return %set_counter_names;
}

# -------------------------------------------------------------------
# Merge two or more hashes together.
# Code from http://search.cpan.org/~rokr/Hash-Merge-Simple-0.051/lib/Hash/Merge/Simple.pm
sub merge {
	my ($left,@right) = @_;
	return $left unless @right;
	return merge($left, merge(@right)) if @right > 1;
	my ($right) = @right;
	my %merge = %$left;
	for my $key (keys %$right) {
		my ($hr, $hl) = map { ref $_->{$key} eq 'HASH' } ($right, $left);
		if (ref $right->{$key} eq "HASH" && ref $left->{$key} eq "HASH") {
			$merge{$key} = merge($left->{$key},$right->{$key});
		} else {
			$merge{$key} = $right->{$key};
		}
	}
	return \%merge;
}

sub clone_merge {
	my $result = merge @_;
	return Clone::clone($result);
}

# -------------------------------------------------------------------
sub repopulateconfiguration {
  my ($node,$parent_node_name) = @_;
	
  my %set_counter_names = set_counters(
																			 $node,
																			 {
																				param=>"init_counter",				   fn=>\&init_counter 	   },
																			 {
																				param=>"pre_increment_counter", fn=>\&increment_counter },
																			 {
																				param=>"pre_set_counter",       fn=>\&set_counter       },
																			);
	
  # default initializer, if init_counter was not called
	if (ref $node && defined $parent_node_name) {
		init_counter($parent_node_name,0) if ! $set_counter_names{$parent_node_name};
	}
	
  for my $key ( keys %$node ) {
		my $value = $node->{$key};
		if ( ref $value eq 'HASH' ) {
			repopulateconfiguration($value,$key);
		} elsif ( ref $value eq 'ARRAY' ) {
			for my $item (@$value) {
				if ( ref $item ) {
					repopulateconfiguration($item,$key);
				}
			}
		} else {
			if ($key =~ /\s+/) {
	      fatal_error("configuration","multi_word_key",$key); 
      }
			my $new_value = parse_field($value,$key,$parent_node_name,$node);
      $node->{$key} = $new_value;
    }
  }
	
  %set_counter_names = set_counters(
																		$node,
																		{
																		 param=>"post_increment_counter", fn=>\&increment_counter },
																		{
																		 param=>"post_set_counter",       fn=>\&set_counter       },
																	 );
	
  # default post increment counter
	if (ref $node && defined $parent_node_name) {
		increment_counter($parent_node_name,1) if ! $set_counter_names{$parent_node_name};
	}
	
}

sub parse_field {

	my ($str,$key,$parent_node_name,$node) = @_;
	my $delim    = "__";
	
	# replace counters 
	# counter(NAME)
	while ( $str =~ /(counter\(\s*(.+?)\s*\))/g ) {
		my ($template,$counter) = ($1,$2);
		if (defined $template && defined $counter) {
			my $new_template = get_counter($counter);
			printdebug_group("counter","fetch",$template,$counter,$new_template);
			$str =~ s/\Q$template\E/$new_template/g;
		}
	}
	# replace configuration field
	# conf(LEAF,LEAF,...)
	while ( $str =~ /(conf\(\s*(.+?)\s*\))/g ) {
		my ($template,$leaf) = ($1,$2);
		if (defined $template && defined $leaf) {
			my @leaf         = split(/\s*,\s*/,$leaf);
			my $new_template;
			if (@leaf == 2 && $leaf[0] eq ".") {
				$new_template = $node->{$leaf[1]};
			} else {
				$new_template = fetch_conf(@leaf);
			}
			printdebug_group("conf","fetch",$template,join(",",@leaf),$new_template);
			$str =~ s/\Q$template\E/$new_template/g;
		}
	}
	
	# this is going to be deprecated
	while ( $str =~ /$delim([^_].+?)$delim/g ) {
		my $source = $delim . $1 . $delim;
		my $target = eval $1;
		printdebug_group("conf","repopulate","key",$key,"value",$str,"var",$1,"target",$target);
		$str =~ s/\Q$source\E/$target/g;
		printdebug_group("conf","repopulate",$key,$str,$target);
	}
	
	if ($str =~ /\s*eval\s*\(\s*(.+)\s*\)/ && $parent_node_name ne "rule" && $str !~ /var\s*\(/) {
		my $fn = $1;
		$str = eval $fn;
		if ($@) {
			fatal_error("rules","parse_error",$fn,$@);
		}
		printdebug_group("conf","repopulateeval",$fn,$str);
	}
	return $str;
}

# -------------------------------------------------------------------
sub loadconfiguration {
  my ($arg,$return) = @_;
  printdebug_group("conf","looking for conf file",$arg);
  my @possibilities = (
											 $arg,
											 catfile( $FindBin::RealBin, $arg ),
											 catfile( $FindBin::RealBin, '..', $arg ),
											 catfile( $FindBin::RealBin, 'etc', $arg ),
											 catfile( $FindBin::RealBin, '..', 'etc', $arg ),
											 catfile( '/home', $ENV{'LOGNAME'}, ".${APP_NAME}.conf" ),
											 catfile( $FindBin::RealBin, "${APP_NAME}.conf" ),
											 catfile( $FindBin::RealBin, 'etc', "${APP_NAME}.conf"),
											 catfile( $FindBin::RealBin, '..', 'etc', "${APP_NAME}.conf"),
											);
  
  my $file;
  for my $f ( @possibilities ) { 
    if ( -e $f && -r _ ) {
      printdebug_group("conf","found conf file",$f);
      $file = $f;
      last;
    }
  }
  
  if ( !$file ) {
    fatal_error("configuration","missing");
  }
  
  my @configpath = (
										dirname($file),
										dirname($file)."/etc",
										"$FindBin::RealBin/etc", 
										"$FindBin::RealBin/../etc",
										"$FindBin::RealBin/..",  
										$FindBin::RealBin,
									 );
	
	
	my $conf;
	eval {
		$conf = Config::General->new(
																 -SplitPolicy       => 'equalsign',
																 -ConfigFile        => $file,
																 -AllowMultiOptions => 1,
																 -LowerCaseNames    => 1,
																 -IncludeAgain      => 1,
																 -ConfigPath        => \@configpath,
																 -AutoTrue => 1
																);
	};
	if ($@) {
		if ($@ =~ /does not exist within configpath/i) {
			fatal_error("configuration","cannot_find_include",join("\n",@configpath),$@);
		} else {
			fatal_error("configuration","cannot_parse_file",$@);
		}
  }
	if ($return) {
		return { $conf->getall } ;
	} else {
		%CONF = $conf->getall;
	}
}

# -------------------------------------------------------------------
sub validateconfiguration {

	if (0) {
		for my $parsekey ( keys %CONF ) {
	    if ( $parsekey =~ /^(__(.+)__)$/ ) {
				if ( !defined $CONF{$1} ) {
					fatal_error("configuration","bad_pointer",$1,$2);
				}
				my ( $token, $parsevalue ) = ($1,$CONF{$1});
				for my $key ( keys %CONF ) {
					$CONF{$key} =~ s/$token/$parsevalue/g;
				}
	    }
		}
	}
    
	if ($CONF{debug} && ! $CONF{debug_group}) {
		$CONF{debug_group} = "summary,io,timer";
	}
    
	$CONF{chromosomes_display_default} = 1 if ! defined $CONF{chromosomes_display_default};
	$CONF{chromosomes_units} ||= 1;
	$CONF{svg_font_scale}    ||= 1;
    
	if ( ! $CONF{karyotype} ) {
		fatal_error("configuration","no_karyotype");
	}
    
	$CONF{image}{image_map_name} ||= $CONF{image_map_name};
	$CONF{image}{image_map_use}  ||= $CONF{image_map_use};
	$CONF{image}{image_map_file} ||= $CONF{image_map_file};
	$CONF{image}{image_map_missing_parameter} ||= $CONF{image_map_missing_parameter};
	$CONF{image}{"24bit"} = 1;
	$CONF{image}{png}  = $CONF{png} if exists $CONF{png};
	$CONF{image}{svg}  = $CONF{svg} if exists $CONF{svg};
	$CONF{image}{file} = $CONF{outputfile} if $CONF{outputfile};
	$CONF{image}{dir}  = $CONF{outputdir}  if $CONF{outputdir};
	$CONF{image}{background} = $CONF{background} if $CONF{background};
    
	if ( $CONF{image}{angle_offset} > 0 ) {
		$CONF{image}{angle_offset} -= 360;
	}
    
	#
	# Make sure these fields are initialized
	#
    
	for my $fld ( qw(chromosomes chromosomes_breaks chromosomes_radius) ) {
		$CONF{ $fld } = $EMPTY_STR if !defined $CONF{ $fld };
	}
    
}

1;
