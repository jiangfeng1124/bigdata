package Circos::Expression;

=pod

=head1 NAME

Circos::Expression - expression and text parsing routines for Geometry in Circos

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
our @EXPORT = qw(
);

use Carp qw( carp confess croak );
use Data::Dumper;
use FindBin;
use Params::Validate qw(:all);
use Math::Round;
use Math::VecStat qw(average);
use List::Util qw(min max);
use Text::Balanced qw(extract_bracketed);

use lib "$FindBin::RealBin";
use lib "$FindBin::RealBin/../lib";
use lib "$FindBin::RealBin/lib";

use Circos::Configuration;
use Circos::Constants;
use Circos::Debug;
use Circos::Error;
use Circos::Utils;

use Memoize;

for my $f (qw(format_condition)) {
	memoize($f);
}

# -------------------------------------------------------------------
sub format_condition {
  #
  # apply suffixes kb, Mb, Gb (case-insensitive) trailing any numbers
  # and apply appropriate multiplier to the number
  #
  my $condition = shift;
  $condition =~ s/([\d\.]+)kb/sprintf("%d",$1*1e3)/eig;
  $condition =~ s/([\d\.]+)Mb/sprintf("%d",$1*1e6)/eig;
  $condition =~ s/([\d\.]+)Gb/sprintf("%d",$1*1e9)/eig;
  $condition =~ s/(\d+)bp/$1/ig;
  return $condition;
}

# -------------------------------------------------------------------
sub eval_expression {
	my $expr = parse_expression(@_);
	my $eval = eval format_condition($expr);
	fatal_error("rules","parse_error",$expr,$@) if $@;
	printdebug_group("rule","expression","[$expr]","eval",$eval);
	return $eval;
}

# -------------------------------------------------------------------
sub parse_expression {
	#
	# var(VAR) refers to variable VAR in the point's data structure
	#
	# e.g.
	#
	# var(CHR)	var(START)  var(END)
	#
	# When the variable name is suffixed with a number, this number
	# indexes the points coordinate. For links, a point has two
	# coordinates 
	#
	# var(CHR1)  var(CHR2)
	#
	# If a point has two coordinates and the non-suffixed version is
	# used, then an error is returned unless the value is the same 
	# for both ends
	#
	# Dynamically generated variables are
	#
	# SIZE
	# POS
	# INTERCHR
	# INTRACHR
	
  my ( $datum, $expr, $param_path ) = @_;

  printdebug_group("rule","eval expression",$expr);
  
  return 1 if true_or_yes($expr);
  return 0 if false_or_no($expr);
  
  my $expr_orig = $expr;
  my $num_coord = @{$datum->{data}};

  # (.+?) replaced by (\w+)
  # parse _field_ and var(field)
  my $delim_rx = qr/(_(\w+)_)/;
  my $var_rx   = qr/(var\((\w+)\))/;
  while ( $expr =~ /$var_rx/i || $expr =~ /$delim_rx/i ) {
		my ($template,$var) = ($1,$2);
		$var = lc $var unless fetch_conf("case_sensitive_parameter_names");
		my ($varroot,$varnum);
		if ($var =~ /^(.+?)(\d+)$/ ) {
			($varroot,$varnum) = ($1,$2);
		} else {
			($varroot,$varnum) = ($var,undef);
		}
		my $value = fetch_variable($datum,$expr,$varroot,$varnum,$param_path);
		replace_string( \$expr, $template, $value );
  }

  # parse functions f(var)
  for my $f (qw(on between fromto tofrom from to )) {
		# for perl 5.10 using recursive rx
		# my $parens = qr/(\((?:[^()]++|(?-1))*+\))/;
		# no longer using this, to make the code compatible with 5.8
		# while( $expr =~ /($f$parens)/ ) {

		while(my ($template,$arg) = extract_balanced($expr,$f,"(",")")) {
			$template = $f . $template;
			if($f eq "on") {
	      my ($arg1) = split(",",$arg);
	      fatal_error("rule","fn_wrong_arg",$f,$expr_orig,1) if ! defined $arg1;
	      #printinfo($template,$arg_nested,$arg,$arg1);
	      my $result = grep($_ =~ /^$arg1$/, map {$_->{chr}} @{$datum->{data}});
	      replace_string( \$expr, $template, $result);
			} elsif ($f eq "between") {
	      my ($arg1,$arg2) = split(",",$arg);
	      fatal_error("rule","fn_wrong_arg",$f,$expr_orig,2) if ! defined $arg1 || ! defined $arg2;
	      fatal_error("rule","fn_need_2_coord",$f,$expr_orig,$arg1,$arg2) if $num_coord != 2;
	      my $result = 
					($datum->{data}[0]{chr} =~ /^$arg1$/i && $datum->{data}[1]{chr} =~ /^$arg2$/i) 
						||
							($datum->{data}[0]{chr} =~ /^$arg2$/i && $datum->{data}[1]{chr} =~ /^$arg1$/i);
	      replace_string( \$expr, $template, $result || 0);
			} elsif ($f eq "fromto") {
	      my ($arg1,$arg2) = split(",",$arg);
	      fatal_error("rule","fn_wrong_arg",$f,$expr_orig,2) if ! defined $arg1 || ! defined $arg2;
	      fatal_error("rule","fn_need_2_coord",$f,$expr_orig,$arg1,$arg2) if $num_coord != 2;
	      my $result = $datum->{data}[0]{chr} =~ /^$arg1$/i && $datum->{data}[1]{chr} =~ /^$arg2$/i;
	      replace_string( \$expr, $template, $result || 0);
			} elsif ($f eq "tofrom") {
	      my ($arg1,$arg2) = split(",",$arg);
	      fatal_error("rule","fn_wrong_arg",$f,$expr_orig,2) if ! defined $arg1 || ! defined $arg2;
	      fatal_error("rule","fn_need_2_coord",$f,$expr_orig,$arg1,$arg2) if $num_coord != 2;
	      my $result = $datum->{data}[0]{chr} =~ /^$arg2$/i && $datum->{data}[1]{chr} =~ /^$arg1$/i;
	      replace_string( \$expr, $template, $result || 0);
			} elsif ($f eq "to") {
	      my ($arg1) = split(",",$arg);
	      fatal_error("rule","fn_wrong_arg",$f,$expr_orig,1) if ! defined $arg1;
	      fatal_error("rule","fn_need_2_coord",$f,$expr_orig,"-",$arg1) if $num_coord != 2;
	      my $result = $datum->{data}[1]{chr} =~ /^$arg1$/i;
	      replace_string( \$expr, $template, $result || 0);
			} elsif ($f eq "from") {
	      my ($arg1) = split(",",$arg);
	      fatal_error("rule","fn_wrong_arg",$f,$expr_orig,1) if ! defined $arg1;
	      fatal_error("rule","fn_need_2_coord",$f,$expr_orig,$arg1,"-") if $num_coord != 2;
	      my $result = $datum->{data}[0]{chr} =~ /^$arg1$/i;
	      replace_string( \$expr, $template, $result || 0);
			}
		}
  }
  return $expr;
}

sub fetch_variable {
	my ($datum,$expr,$var,$varnum,$param_path) = @_;
	my $num_coord = @{$datum->{data}};
	# If this data collection has only one data value (e.g. scatter plot)
	# then assume that any expression without an explicit number is refering
	# to the data point (e.g. _SIZE_ acts like _SIZE1_)
	if($num_coord == 1) {
		if(! defined $varnum) {
	    # var(START) treated like var(START1)
	    $varnum = 1;
		} elsif ($varnum != 1) {
	    # var(STARTN) must have N=1
	    fatal_error("rule","bad_coord",$var,$varnum,$num_coord);					
		}
	} elsif ($num_coord == 2) {
		if(! defined $varnum) {
	    # var(START) treated like var(START1) but only if var(START1) == var(START2)
	    my $v1 = fetch_variable($datum,$expr,$var,1,$param_path);
	    my $v2 = fetch_variable($datum,$expr,$var,2,$param_path);
	    if($v1 eq $v2) {
				return $v1;
	    } else {
				fatal_error("rule","conflicting_coord",
										$var,$num_coord,
										$v1,$v2,
										$var,$var);
	    }
		} elsif ($varnum != 1 && $varnum != 2) {
	    # var(STARTN) must have N=1 or N=2
	    fatal_error("rule","bad_coord",$var,$varnum,$num_coord);					
		}
	} else {
		fatal_error("rule","wrong_coord_num",$num_coord);
	}

	my $varidx = $varnum - 1;
	my $data = $datum->{data};
	my $value;
	$var = lc $var unless fetch_conf("case_sensitive_parameter_names");
	if( exists $datum->{param}{$var} ) {
		$value = $datum->{param}{$var};
	} elsif ( exists $data->[$varidx]{$var} ) {
		$value = $data->[$varidx]{$var};
	} elsif ( $param_path && defined seek_parameter( $var, @$param_path ) ) {
		$value = seek_parameter( $var, @$param_path );
	} elsif ( $var eq "size" ) {
		$value = $data->[$varidx]{end} - $data->[$varidx]{start} + 1;
	} elsif ( $var eq "pos" ) {
		$value = round ($data->[$varidx]{start}+$data->[$varidx]{end})/2;
	} elsif ( $var eq "intrachr" ) {
		fatal_error("rule","need_2_coord","intrachr",$num_coord) if $num_coord != 2;
		$value = $data->[0]{chr} eq $data->[1]{chr} ? 1 : 0;
	} elsif ( $var eq "interchr" ) {
		fatal_error("rule","need_2_coord","intrachr",$num_coord) if $num_coord != 2;
		$value = $data->[0]{chr} ne $data->[1]{chr} ? 1 : 0;
	} else {
		if(fetch_conf("skip_missing_expression_vars")) {
	    $value = $EMPTY_STR;
		} else {
	    fatal_error("rules","no_such_field",$expr,$var,Dumper($datum));
		}
	}
	$value = Circos::unit_strip($value);
	printdebug_group("rule","found variable",$var."[$varnum]","value",$value);
	return $value;
}

# -------------------------------------------------------------------
sub replace_string {
  my ( $target, $source, $value ) = @_;
  if ( $value =~ /[^0-9-.]/ && $value ne "undef" ) {
    $$target =~ s/\Q$source\E/'$value'/g;
  } else {
    $$target =~ s/\Q$source\E/$value/g;
  }
}


################################################################
# Given an expression (e.g. var(abc) == 1) and a prefix (e.g. var)
# extract arguments that follow the prefix which are encapsulated
# in balanced delimiters (delim_start, delim_end)
#
# Returns the raw arguments and a version stripped of delimiters
#
# var (abc ( def ) )def(a) 
#
# returns
#
# (abc ( def ) )
# abc ( def )
#
# If no balanced argument is found, returns undef

sub extract_balanced {
	my ($expr,$prefix,$delim_start,$delim_end) = @_;
	if($expr =~ /($prefix\s*)(\Q$delim_start\E.*)/) {
		my $arg = $2;
		my @result = extract_bracketed($arg,$delim_start);
		if(defined $result[0]) {
			my $balanced = $result[0];
			$balanced =~ s/^\s*\Q$delim_start\E\s*//;
			$balanced =~ s/\s*\Q$delim_end\E\s*$//;
			return ($result[0],$balanced);
		}
	}
	return;
}

1;
