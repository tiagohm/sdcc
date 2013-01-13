#!/usr/bin/perl -w

=back

  Copyright (C) 2013, Molnar Karoly <molnarkaroly@users.sf.net>

    This software is provided 'as-is', without any express or implied
    warranty.  In no event will the authors be held liable for any damages
    arising from the use of this software.

    Permission is granted to anyone to use this software for any purpose,
    including commercial applications, and to alter it and redistribute it
    freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not
       claim that you wrote the original software. If you use this software
       in a product, an acknowledgment in the product documentation would be
       appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be
       misrepresented as being the original software.

    3. This notice may not be removed or altered from any source distribution.

================================================================================

    This program disassembles the hex files. It assumes that the hex file
    contains MCS51 instructions.

    Proposal for use: ./mcs51-disasm.pl -M 8052.h program.hex > program.asm

  $Id$
=cut

use strict;
use warnings;
use 5.12.0;                     # when (regex)

use constant FALSE	=> 0;
use constant TRUE	=> 1;

use constant TAB_LENGTH	=> 8;

################################################################################

use constant INHX8M			=> 0;
use constant INHX32			=> 2;

use constant INHX_DATA_REC		=> 0;
use constant INHX_EOF_REC		=> 1;
use constant INHX_EXT_LIN_ADDR_REC	=> 4;

use constant EMPTY			=> -1;

use constant COUNT_SIZE			=> 2;
use constant ADDR_SIZE			=> 4;
use constant TYPE_SIZE			=> 2;
use constant BYTE_SIZE			=> 2;
use constant CRC_SIZE			=> 2;
use constant HEADER_SIZE		=> (COUNT_SIZE + ADDR_SIZE + TYPE_SIZE);
use constant MIN_LINE_LENGTH		=> (HEADER_SIZE + CRC_SIZE);

use constant MCS51_ROM_SIZE		=> 0x10000;

################################################################################

my $PROGRAM = 'mcs51-disasm.pl';

my $border0 = ('-' x 79);
my $border1 = ('#' x 79);

my @default_paths =
  (
  '/usr/share/sdcc/include/mcs51',
  '/usr/local/share/sdcc/include/mcs51'
  );

my $default_include_path = '';
my $include_path = '';
my $hex_file = '';
my $map_file = '';
my $header_file = '';

my $verbose           = 0;
my $hex_constant      = FALSE;
my $gen_assembly_code = FALSE;
my $no_explanations   = FALSE;

my @rom = ();
my $rom_size = MCS51_ROM_SIZE;
my %const_areas_by_address = ();

=back
	Structure of one element of %labels_by_address:

	{
	NAME    => '',
	TYPE    => 0,
	PRINTED => FALSE
	}
=cut

use constant LABEL => 1;
use constant SUB   => 2;

my %labels_by_address = ();
my $max_label_addr = 0;

my %sfrs_by_address = ();
my %sfrs_by_names   = ();
my %bits_by_address = ();

my %variables_by_address = ();
my $max_variable_addr = 0;

	# Sizes of the instructions.

my @instruction_sizes =
  (
  1, 2, 3, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  3, 2, 3, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  3, 2, 1, 1, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  3, 2, 1, 1, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  2, 2, 2, 3, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  2, 2, 2, 3, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  2, 2, 2, 3, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  2, 2, 2, 1, 2, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  2, 2, 2, 1, 1, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  3, 2, 2, 1, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  2, 2, 2, 1, 1, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  2, 2, 2, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
  2, 2, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  2, 2, 2, 1, 1, 3, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2,
  1, 2, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  1, 2, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
  );

use constant DPL => 0x82;
use constant DPH => 0x83;
use constant PSW => 0xD0;

my $DPTR;
my @R_regs;

my $prev_is_jump;

use constant ALIGN_SIZE  => 5;
use constant TBL_COLUMNS => 8;

=back
	The structure of one element of the %blocks_by_address hash:

	{
	TYPE  => 0,
	ADDR  => 0,
	SIZE  => 0,
	LABEL => 0
	}
=cut

use constant BLOCK_INSTR => 0x00;
use constant BLOCK_CONST => 0x01;
use constant BLOCK_EMPTY => 0x02;

use constant BL_LABEL_NONE  => 0x00;
use constant BL_LABEL_SUB   => 0x11;
use constant BL_LABEL_LABEL => 0x12;

my %blocks_by_address = ();

my %interrupts_by_address =
  (
  0x0000 => 'System_init',
  0x0003 => 'Int0_interrupt',
  0x000B => 'Timer0_interrupt',
  0x0013 => 'Int1_interrupt',
  0x001B => 'Timer1_interrupt',
  0x0023 => 'Uart_interrupt',
  0x002B => 'Timer2_interrupt',
  0x0033 => 'Int2_interrupt',
  0x003B => 'Int3_interrupt'
  );

my %control_characters =
  (
  0x00 => '\0',
  0x07 => '\a',
  0x08 => '\b',
  0x09 => '\t',
  0x0A => '\n',
  0x0C => '\f',
  0x0D => '\r',
  0x1B => '\e',
  0x7F => '^?'
  );

my $dcd_address    = 0;
my $dcd_instr_size = 0;
my $dcd_instr	   = 0;
my $dcd_parm0	   = 0;
my $dcd_parm1	   = 0;
my $dcd_Ri_regs    = 0;
my $dcd_Ri_name    = '';
my $dcd_Rn_regs    = 0;
my $dcd_Rn_name    = '';

################################################################################
################################################################################

my %pp_defines = ();            # Value of definitions.

my @pp_conditions = ();
my @pp_else_conditions = ();
my $pp_level = 0;               # Shows the lowest level.
my $embed_level;

#   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@@@@@@@@@@                             @@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@@@@@@@@@  This a simple preprocessor.  @@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@@@@@@@@@@                             @@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	# Examines that the parameter is defined or not defined.

sub _defined($)
  {
  return defined($pp_defines{$_[0]});
  }

#-------------------------------------------------------------------------------

	# Records a definition.

sub define($)
  {
  my ($Name) = ($_[0] =~ /^(\S+)/o);
  my $Body = ${^POSTMATCH};

  $Body =~ s/^\s+//o;

  die "define(): This definition already exists: \"$Name\"\n" if (_defined($Name));

        # The definition is in fact unnecessary.
  $pp_defines{$Name} = $Body;
  }

#-------------------------------------------------------------------------------

	# Delete a definition.

sub undefine($)
  {
  delete($pp_defines{$_[0]});
  }

#-------------------------------------------------------------------------------

	# Evaluation of the #if give a boolean value. This procedure preserves it.

sub if_condition($)
  {
  my $Val = $_[0];

  push(@pp_conditions, $Val);
  push(@pp_else_conditions, $Val);
  ++$pp_level;
  }

#-------------------------------------------------------------------------------

	# Evaluation of the #else give a boolean value. This procedure preserves it.

sub else_condition($$)
  {
  my ($File, $Line_number) = @_;

  die "else_condition(): The ${Line_number}th line of $File there is a #else, but does not belong him #if.\n" if ($pp_level <= 0);

  my $last = $#pp_conditions;

  if ($last > 0 && $pp_conditions[$last - 1])
    {
    $pp_conditions[$last] = ($pp_else_conditions[$#pp_else_conditions]) ? FALSE : TRUE;
    }
  else
    {
    $pp_conditions[$last] = FALSE;
    }
  }

#-------------------------------------------------------------------------------

	# Closes a logical unit which starts with a #if.

sub endif_condition($$)
  {
  my ($File, $Line_number) = @_;

  die "endif_condition(): The ${Line_number}th line of $File there is a #endif, but does not belong him #if.\n" if ($pp_level <= 0);

  pop(@pp_conditions);
  pop(@pp_else_conditions);
  --$pp_level;
  }

#-------------------------------------------------------------------------------

sub reset_preprocessor()
  {
  %pp_defines = ();
  @pp_conditions = ();
  push(@pp_conditions, TRUE);
  @pp_else_conditions = ();
  push(@pp_else_conditions, FALSE);
  $pp_level = 0;
  }

#-------------------------------------------------------------------------------

        # This the preprocessor.

sub run_preprocessor($$$$)
  {
  my ($Fname, $Function, $Line, $Line_number) = @_;

  if ($Line =~ /^#\s*ifdef\s+(\S+)$/o)
    {
    if ($pp_conditions[$#pp_conditions])
      {
        # The ancestor is valid, therefore it should be determined that
        # the descendants what kind.

      if_condition(_defined($1));
      }
    else
      {
        # The ancestor is invalid, so the descendants will invalid also.

      if_condition(FALSE);
      }
    }
  elsif ($Line =~ /^#\s*ifndef\s+(\S+)$/o)
    {
    if ($pp_conditions[$#pp_conditions])
      {
        # The ancestor is valid, therefore it should be determined that
        # the descendants what kind.

      if_condition(! _defined($1));
      }
    else
      {
        # The ancestor is invalid, so the descendants will invalid also.

      if_condition(FALSE);
      }
    }
  elsif ($Line =~ /^#\s*else/o)
    {
    else_condition($Fname, $Line_number);
    }
  elsif ($Line =~ /^#\s*endif/o)
    {
    endif_condition($Fname, $Line_number);
    }
  elsif ($Line =~ /^#\s*define\s+(.+)$/o)
    {
        # This level is valid, so it should be recorded in the definition.

    define($1) if ($pp_conditions[$#pp_conditions]);
    }
  elsif ($Line =~ /^#\s*undef\s+(.+)$/o)
    {
        # This level is valid, so it should be deleted in the definition.

    undefine($1) if ($pp_conditions[$#pp_conditions]);
    }
  elsif ($pp_conditions[$#pp_conditions])
    {
        # This is a valid line. (The whole magic is in fact therefore there is.)

    $Function->($Line);
    }
  }

################################################################################
################################################################################
################################################################################

sub basename($)
  {
  return ($_[0] =~ /([^\/]+)$/) ? $1 : '';
  }

#-------------------------------------------------------------------------------

sub param_exist($$)
  {
  die "This option \"$_[0]\" requires a parameter.\n" if ($_[1] > $#ARGV);
  }

#-------------------------------------------------------------------------------

sub Log
  {
  return if (pop(@_) > $verbose);
  foreach (@_) { print STDERR $_; }
  print STDERR "\n";
  }

#-------------------------------------------------------------------------------

sub str2int($)
  {
  my $Str = $_[0];

  return hex($1)   if ($Str =~ /^0x([[:xdigit:]]+)$/io);
  return int($Str) if ($Str =~ /^-?\d+$/o);

  die "str2int(): This string not integer: \"$Str\"";
  }

#-------------------------------------------------------------------------------

	#
	# Before print, formats the $Text.
	#

sub align($$)
  {
  my $Text = $_[0];
  my $al   = $_[1] - int(length($Text) / TAB_LENGTH);

	# One space will surely becomes behind it.
  if ($al < 1)
    {
    return "$Text ";
    }
  else
    {
    return ($Text . "\t" x $al);
    }
  }

#-------------------------------------------------------------------------------

	#
	# Multiple file test.
	#

sub is_file_ok($)
  {
  my $File = $_[0];

  if (! -e $File)
    {
    print STDERR "$PROGRAM: Not exists -> \"$File\"\n";
    exit(1);
    }

  if (! -f $File)
    {
    print STDERR "$PROGRAM: Not file -> \"$File\"\n";
    exit(1);
    }

  if (! -r $File)
    {
    print STDERR "$PROGRAM: Can not read -> \"$File\"\n";
    exit(1);
    }

  if (! -s $File)
    {
    print STDERR "$PROGRAM: Empty file -> \"$File\"\n";
    exit(1);
    }
  }

#-------------------------------------------------------------------------------

	#
	# Initializes the @rom array.
	#

sub init_mem($$)
  {
  my ($Start, $End) = @_;

  @rom[$Start .. $End] = ((EMPTY) x ($End - $Start + 1));
  }

#-------------------------------------------------------------------------------

	#
	# Store values of the $Code to $AddrRef address.
	#

sub store_code($$)
  {
  my ($Code, $AddrRef) = @_;

  if ($$AddrRef >= $rom_size)
    {
    printf STDERR "Warning, this address (0x%04X) outside the code area (0x%04X)!\n", $$AddrRef, $rom_size - 1;
    }

  Log(sprintf("rom[0x%08X] = 0x%02X", $$AddrRef, $Code), 9);
  $rom[$$AddrRef++] = $Code;
  }

#-------------------------------------------------------------------------------

        #
        # Reads contents of the $Hex.
        #

sub read_hex($)
  {
  my $Hex = $_[0];
  my $addr_H;
  my $format = INHX32;

  if (! open(IN, '<', $Hex))
    {
    print STDERR "$PROGRAM : Could not open. -> \"$Hex\"\n";
    exit(1);
    }

  $addr_H = 0;

  while (<IN>)
    {
    chomp;
    s/\r$//o;

    my $len = length() - 1;

    if ($len < MIN_LINE_LENGTH)
      {
      close(IN);
      print STDERR "$PROGRAM: ${.}th line <- Shorter than %u character.\n", MIN_LINE_LENGTH;
      exit(1);
      }

    Log("$..(1) (\"$_\") length() = " . length(), 7);

    my $bytecount = int(($len - MIN_LINE_LENGTH) / BYTE_SIZE);

    my $binrec = pack('H*', substr($_, 1));

    if (unpack('%8C*', $binrec) != 0)
      {
      close(IN);
      print STDERR "$PROGRAM: $Hex <- Crc error. (${.}th line \"$_\").\n";
      exit(1);
      }

    my ($count, $addr, $type, $bytes) = unpack('CnCX4Cx3/a', $binrec);

    my @codes = unpack('C*', $bytes);

    Log(sprintf("$..(2) (\"$_\") count = $count, bytecount = $bytecount, addr = 0x%04X, type = $type", $addr), 7);

    if ($type == INHX_EOF_REC)
      {
      last;
      }
    elsif ($type == INHX_EXT_LIN_ADDR_REC)
      {
      $addr_H = unpack('n', $bytes);	# big-endian

      Log(sprintf("$..(3) (\"$_\") addr_H = 0x%04X\n", $addr_H), 7);

      $format = INHX32;
      Log('format = INHX32', 7);
      next;
      }
    elsif ($type != INHX_DATA_REC)
      {
      close(IN);
      printf STDERR "$PROGRAM: $Hex <- Unknown type of record: 0x%02X (${.}th line \"$_\").\n", $type;
      exit(1);
      }

    if ($bytecount == $count)			# INHX32
      {
      if ($format == INHX8M)
	{
	close(IN);
	print STDERR "$PROGRAM: $Hex <- Mixed format of file (${.}th line \"$_\").\n";
	exit(1);
	}

      my $addr32 = ($addr_H << 16) | $addr;

      map { store_code($_, \$addr32) } @codes;
      }
    elsif ($bytecount == ($count * BYTE_SIZE))	# INHX8M
      {
      if ($format == INHX32)
	{
	close(IN);
	print STDERR "$PROGRAM: $Hex <- Mixed format of file (${.}th line \"$_\").\n";
	exit(1);
	}

      map { store_code($_, \$addr) } @codes;
      }
    else
      {
      close(IN);
      print STDERR "$PROGRAM: $Hex <- Wrong format of file (${.}th line \"$_\").\n";
      exit(1);
      }
    } # while (<IN>)

  close(IN);
  }

#-------------------------------------------------------------------------------

	#
	# Determines that the $Address belongs to a constant.
	#

sub is_constant($)
  {
  my $Address = $_[0];

  foreach (keys(%const_areas_by_address))
    {
    return TRUE if ($_ <= $Address && $Address <= $const_areas_by_address{$_});
    }

  return FALSE;
  }

#-------------------------------------------------------------------------------

sub add_block($$$$)
  {
  my ($Address, $Type, $Size, $LabelType) = @_;

  if (! defined($blocks_by_address{$Address}))
    {
    $blocks_by_address{$Address} = {
				   TYPE  => $Type,
				   ADDR  => $Address,
				   SIZE  => $Size,
				   LABEL => $LabelType
				   };
    }
  else
    {
    my $ref = $blocks_by_address{$Address};

    $ref->{SIZE}  = $Size      if ($Size > 0);
    $ref->{LABEL} = $LabelType if ($LabelType != BL_LABEL_NONE);
    }
  }

#-------------------------------------------------------------------------------

	#
	# Store address entry of a procedure.
	#

sub add_func_label($)
  {
  my $Address = $_[0];

  if ($Address < 0)
    {
    Log(sprintf("add_func_label(): This address (0x%04X) negative!", $Address), 2);
    return;
    }

  if (! defined($blocks_by_address{$Address}))
    {
    Log(sprintf("add_func_label(): This address (0x%04X) does not shows an instruction!", $Address), 2);
    return;
    }

  if (is_constant($Address))
    {
    Log(sprintf("add_func_label(): This address (0x%04X) outside the code area (0x%04X)!", $Address, $rom_size - 1), 2);
    return;
    }

  if (! defined($labels_by_address{$Address}))
    {
    $max_label_addr = $Address if ($max_label_addr < $Address);
    }

  $labels_by_address{$Address}->{TYPE} = SUB;
  add_block($Address, BLOCK_INSTR, 0, BL_LABEL_SUB);
  }

#-------------------------------------------------------------------------------

	#
	# Store a label.
	#

sub add_jump_label($$)
  {
  my ($TargetAddr, $SourceAddr) = @_;
  my $label;

  if ($TargetAddr < 0)
    {
    Log(sprintf("add_jump_label(): This address (0x%04X) negative!", $TargetAddr), 2);
    return;
    }

  if (! defined($blocks_by_address{$TargetAddr}))
    {
    Log(sprintf("add_jump_label(): This address (0x%04X) does not shows an instruction!", $TargetAddr), 2);
    return;
    }

  if (is_constant($TargetAddr))
    {
    Log(sprintf("add_jump_label(): This address (0x%04X) outside the code area (0x%04X)!", $TargetAddr, $rom_size - 1), 2);
    return;
    }

  if (! defined($labels_by_address{$TargetAddr}))
    {
    $labels_by_address{$TargetAddr}->{TYPE} = LABEL;
    $label = \%{$labels_by_address{$TargetAddr}};

	#
	# This is the interrupt vector table. The handlers gets unique names.
	#

    if (defined($interrupts_by_address{$SourceAddr}))
      {
      $label->{NAME} = $interrupts_by_address{$SourceAddr};
      $label->{TYPE} = SUB;
      }

    $max_label_addr = $TargetAddr if ($max_label_addr < $TargetAddr);
    $label->{PRINTED} = FALSE;
    add_block($TargetAddr, BLOCK_INSTR, 0, BL_LABEL_LABEL);
    }
  }

################################################################################
################################################################################

use constant MAP_NULL   => 0;
use constant MAP_BORDER => 1;
use constant MAP_AREA   => 2;
use constant MAP_CABS   => 3;
use constant MAP_CODE0  => 4;
use constant MAP_CODE1  => 5;
use constant MAP_DATA   => 6;
use constant MAP_CONST  => 7;

        #
        # If exists the map file, then extracts out of it the labels,
        # variables and some segments.
        #

sub read_map_file()
  {
  my ($addr, $name, $state, $label);

  return if ($map_file eq '');

  $state = MAP_NULL;

  if (! open(MAP, '<', $map_file))
    {
    print STDERR "$PROGRAM : Could not open. -> \"$map_file\"\n";
    exit(1);
    }

  while (<MAP>)
    {
    chomp;
    s/\r$//o;

    if ($state == MAP_NULL)
      {
      $state = MAP_BORDER if (/^Area\s+/io);
      }
    elsif ($state == MAP_BORDER)
      {
      $state = MAP_AREA if (/^-+\s+/o);
      }
    elsif ($state == MAP_AREA)
      {
      if (/^CABS\s+/o)
	{
	$state = MAP_CABS;
	}
      elsif (/^(HOME|CSEG)\s+/o)
	{
	$state = MAP_CODE0;
	}
      elsif (/^GSINIT\d+\s+/o)
	{
	$state = MAP_CODE1;
	}
      elsif (/^DSEG\s+/o)
	{
	$state = MAP_DATA;
	}
      elsif (/^CONST\s+([[:xdigit:]]+)\s+([[:xdigit:]]+)\s+/o)
	{
	my ($start, $size) = (hex($1), hex($2));

	$const_areas_by_address{$start} = $start + $size - 1;
	$state = MAP_CONST;
	}
      else
	{
	$state = MAP_NULL;
	}
      }
    elsif ($state == MAP_CABS)
      {
      if (/^.ASxxxx Linker\s+/io)
        {
        $state = MAP_NULL;
        }
      elsif (/^C:\s+([[:xdigit:]]+)\s+(\S+)/o)
	{
	($addr, $name) = (hex($1), $2);

	if ($name eq 's_CONST' || $name eq 's_XINIT')
	  {
	# C:   000001E8  s_CONST
	# C:   00000215  s_XINIT

	  $label = \%{$labels_by_address{$addr}};
	  $label->{NAME} = $name;
	  $label->{TYPE} = LABEL;
	  }
	}
      } # elsif ($state == MAP_CABS)
    elsif ($state == MAP_CODE0 || $state == MAP_CODE1)
      {
      if (/^.ASxxxx Linker\s+/io)
        {
        $state = MAP_NULL;
        }
      elsif (/^C:\s+([[:xdigit:]]+)\s+(\S+)/o)
	{
	# C:   00000040  __mcs51_genXINIT
	# C:   00000061  __mcs51_genRAMCLEAR
	# C:   00000067  __mcs51_genXRAMCLEAR
	# C:   00000086  _Uart_int                          main
	# C:   000000CE  _toHexChar                         main
	# C:   000001E4  __sdcc_external_startup            _startup

	($addr, $name) = (hex($1), $2);

	$label = \%{$labels_by_address{$addr}};
	$label->{NAME} = $name;
	$label->{TYPE} = ($state == MAP_CODE0) ? SUB : LABEL;
	}
      } # elsif ($state == MAP_CODE0 || $state == MAP_CODE1)
    elsif ($state == MAP_DATA)
      {
      if (/^.ASxxxx Linker\s+/io)
        {
        $state = MAP_NULL;
        }
      elsif (/^\s*([[:xdigit:]]+)\s+(\S+)/o)
	{
	# 00000039  _counter                           data
	# 0000004C  _flash_read_PARM_2                 flash

	($addr, $name) = (hex($1), $2);

	$variables_by_address{$addr} = $name if (! defined($variables_by_address{$addr}));

	$max_variable_addr = $addr if ($max_variable_addr < $addr);
	}
      } # elsif ($state == MAP_DATA)
    elsif ($state == MAP_CONST)
      {
      $state = MAP_NULL if (/^.ASxxxx Linker\s+/io);
      }
    } # while (<MAP>)

  close(MAP);
  }

#-------------------------------------------------------------------------------

	#
	# There are some variables that are multi-byte. However, only
	# the LSB byte of having a name. This procedure gives a name
	# for the higher-significant bytes.
	#

sub fix_multi_byte_variables()
  {
  my $prev_addr = EMPTY;
  my $prev_name = '';
  my ($i, $var_size);

  foreach (sort {$a <=> $b} keys(%variables_by_address))
    {
    if ($prev_addr > EMPTY)
      {
      $var_size = $_ - $prev_addr;

      if ($var_size > 1)
	{
	# This is a multi-byte variable.

	for ($i = 1; $i < $var_size; ++$i)
	  {
	  $variables_by_address{$prev_addr + $i} = "($prev_name + $i)";
	  }
	}
      }

    $prev_addr = $_;
    $prev_name = $variables_by_address{$_};
    }
  }

#-------------------------------------------------------------------------------

        #
        # If there is left in yet so label that has no name, this here get one.
        # 

sub add_names_labels()
  {
  my ($addr, $fidx, $label, $lidx);

  $fidx = 0;
  $lidx = 0;
  for ($addr = 0; $addr <= $max_label_addr; ++$addr)
    {
    if (defined($labels_by_address{$addr}))
      {
      $label = \%{$labels_by_address{$addr}};

      next if (defined($label->{NAME}) && $label->{NAME} ne '');

      if ($label->{TYPE} == SUB)
	{
	$label->{NAME} = sprintf("Function_%03u", $fidx++);
	}
      elsif ($label->{TYPE} == LABEL)
	{
	$label->{NAME} = sprintf("Label_%03u", $lidx++);
	}
      }
    }
  }

################################################################################
################################################################################

=back
        Instruction set of the 8051 family:

	NOP				00000000
	AJMP	addr11			aaa00001 aaaaaaaa		a10 a9 a8 1 0 0 0 1	a7-a0
	LJMP	addr16			00000010 aaaaaaaa aaaaaaaa	a15-a8 a7-a0	absolute address
	RR	A			00000011
	INC	A			00000100
	INC	direct			00000101 aaaaaaaa		register address
	INC	@Ri			0000011i			R0 .. R1
	INC	Rn			00001rrr			R0 .. R7
	JBC	bit, rel		00010000 bbbbbbbb rrrrrrrr	bit address	relative address
	ACALL	addr11			aaa10001 aaaaaaaa		a10 a9 a8 1 0 0 0 1	a7-a0
	LCALL	addr16			00010010 aaaaaaaa aaaaaaaa	a15-a8 a7-a0	absolute address
	RRC	A			00010011
	DEC	A			00010100
	DEC	direct			00010101 aaaaaaaa		register address
	DEC	@Ri			0001011i			R0 .. R1
	DEC	Rn			00011rrr			R0 .. R7
	JB	bit, rel		00100000 bbbbbbbb rrrrrrrr	bit address	relative address
	RET				00100010
	RL	A			00100011
	ADD	A, #data		00100100 dddddddd		adat
	ADD	A, direct		00100101 aaaaaaaa		register address
	ADD	A, @Ri			0010011i			R0 .. R1
	ADD	A, Rn			00101rrr			R0 .. R7
	JNB	bit, rel		00110000 bbbbbbbb rrrrrrrr	bit address	relative address
	RETI				00110010
	RLC	A			00110011
	ADDC	A, #data		00110100 dddddddd		adat
	ADDC	A, direct		00110101 aaaaaaaa		register address
	ADDC	A, @Ri			0011011i			R0 .. R1
	ADDC	A, Rn			00111rrr			R0 .. R7
	JC	rel			01000000 rrrrrrrr 		relative address
	ORL	direct, A		01000010 aaaaaaaa		register address
	ORL	direct, #data		01000011 aaaaaaaa dddddddd	register address	adat
	ORL	A, #data		01000100 dddddddd		adat
	ORL	A, direct		01000101 aaaaaaaa		register address
	ORL	A, @Ri			0100011i			R0 .. R1
	ORL	A, Rn			01001rrr		        R0 .. R7
	JNC	rel			01010000 rrrrrrrr 		relative address
	ANL	direct, A		01010010 aaaaaaaa		register address
	ANL	direct, #data		01010011 aaaaaaaa dddddddd	register address	adat
	ANL	A, #data		01010100 dddddddd		adat
	ANL	A, direct		01010101 aaaaaaaa		register address
	ANL	A, @Ri			0101011i			R0 .. R1
	ANL	A, Rn			01011rrr			R0 .. R7
	JZ	rel			01100000 rrrrrrrr 		relative address
	XRL	direct, A		01100010 aaaaaaaa		register address
	XRL	direct, #data		01100011 aaaaaaaa dddddddd	register address	adat
	XRL	A, #data		01100100 dddddddd		adat
	XRL	A, direct		01100101 aaaaaaaa		register address
	XRL	A, @Ri			0110011i			R0 .. R1
	XRL	A, Rn			01101rrr			R0 .. R7
	JNZ	rel			01110000 rrrrrrrr 		relative address
	ORL	C, bit			01110010 bbbbbbbb		bit address
	JMP	@A+DPTR			01110011
	MOV	A, #data		01110100 dddddddd		adat
	MOV	direct, #data		01110101 aaaaaaaa dddddddd	register address	adat
	MOV	@Ri, #data		0111011i dddddddd		adat
	MOV	Rn, #data		01111rrr dddddddd		R0 .. R7	adat
	SJMP	rel			10000000 rrrrrrrr		relative address
	ANL	C, bit			10000010 bbbbbbbb		bit address
	MOVC	A, @A+PC		10000011
	DIV	AB			10000100
	MOV	direct, direct		10000101 aaaaaaaa aaaaaaaa	forrás reg.	cél reg.
	MOV	direct, @Ri		1000011i aaaaaaaa		R0 .. R1	register address
	MOV	direct, Rn		10001rrr aaaaaaaa		R0 .. R7	register address
	MOV	DPTR, #data16		10010000 dddddddd dddddddd	d15-d8 d7-d0
	MOV	bit, C			10010010 bbbbbbbb		bit address
	MOVC	A, @A+DPTR		10010011
	SUBB	A, #data		10010100 dddddddd		adat
	SUBB	A, direct		10010101 aaaaaaaa		register address
	SUBB	A, @Ri			1001011i			R0 .. R1
	SUBB	A, Rn			10011rrr			R0 .. R7
	ORL	C, /bit			10100000 bbbbbbbb		bit address
	MOV	C, bit			10100010 bbbbbbbb		bit address
	INC	DPTR			10100011
	MUL	AB			10100100
	MOV	@Ri, direct		1010011i aaaaaaaa		register address
	MOV	Rn, direct		10101rrr aaaaaaaa		R0 .. R7	register address
	ANL	C, /bit			10110000 bbbbbbbb		bit address
	CPL	bit			10110010 bbbbbbbb		bit address
	CPL	C			10110011
	CJNE	A, #data, rel		10110100 dddddddd rrrrrrrr	adat		relative address
	CJNE	A, direct, rel		10110101 aaaaaaaa rrrrrrrr	register address	relative address
	CJNE	@Ri, #data, rel		1011011i dddddddd rrrrrrrr	R0 .. R1 	data	relative address
	CJNE	Rn, #data, rel		10111rrr dddddddd rrrrrrrr	R0 .. R7 	data	relative address
	PUSH	direct			11000000 aaaaaaaa		register address
	CLR	bit			11000010 bbbbbbbb		bit address
	CLR	C			11000011
	SWAP	A			11000100
	XCH	A, direct		11000101 aaaaaaaa		register address
	XCH	A, @Ri			1100011i			R0 .. R1
	XCH	A, Rn			11001rrr			R0 .. R7
	POP	direct			11010000 aaaaaaaa		register address
	SETB	bit			11010010 bbbbbbbb		bit address
	SETB	C			11010011
	DA	A			11010100
	DJNZ	direct, rel		11010101 aaaaaaaa rrrrrrrr	register address	relative address
	XCHD	A, @Ri			1101011i			R0 .. R1
	DJNZ	Rn, rel			11011rrr rrrrrrrr		R0 .. R7	relative address
	MOVX	A, @DPTR		11100000
	MOVX	A, @Ri			1110001i			R0 .. R1
	CLR	A			11100100
	MOV	A, direct		11100101 aaaaaaaa		register address	The "MOV A, ACC" invalid instruction.
	MOV	A, @Ri			1110011i			R0 .. R1
	MOV	A, Rn			11101rrr			R0 .. R7
	MOVX	@DPTR, A		11110000
	MOVX	@Ri, A			1111001i			R0 .. R1
	CPL	A			11110100
	MOV	direct, A		11110101 aaaaaaaa		register address
	MOV	@Ri, A			1111011i			R0 .. R1
	MOV	Rn, A			11111rrr			R0 .. R7
=cut

#-------------------------------------------------------------------------------

	#
	# Expand a relative offset value.
	#

sub expand_offset($)
  {
  my $Offset = $_[0];

  return ($Offset & 0x80) ? -(($Offset ^ 0xFF) + 1) : $Offset;
  }

#-------------------------------------------------------------------------------

        #
	# Finds address of branchs and procedures.
        #

sub label_finder($)
  {
  my $BlockRef = $_[0];
  my ($instr_size, $address, $instr);
  my ($addr, $instr_mask0, $instr_mask1, $instr_mask2);

  $address     = $BlockRef->{ADDR};
  $instr_size  = $BlockRef->{SIZE};
  $instr       = $rom[$address];

  $instr_mask0 = $instr & 0x1F;
  $instr_mask1 = $instr & 0xFE;
  $instr_mask2 = $instr & 0xF8;

  if ($instr_mask0 == 0x01)
    {
        # AJMP	addr11			aaa00001 aaaaaaaa		a10 a9 a8 0 0 0 0 1	a7-a0

    $addr = (($address + $instr_size) & 0xF800) | (($instr & 0xE0) << 3) | $rom[$address + 1];
    add_jump_label($addr, $address);
    }
  elsif ($instr_mask0 == 0x11)
    {
	# ACALL	addr11			aaa10001 aaaaaaaa		a10 a9 a8 1 0 0 0 1	a7-a0

    $addr = (($address + $instr_size) & 0xF800) | (($instr & 0xE0) << 3) | $rom[$address + 1];
    add_func_label($addr);
    }
  elsif ($instr_mask1 == 0xB6 || $instr_mask2 == 0xB8)
    {
	# CJNE	@Ri, #data, rel		1011011i dddddddd rrrrrrrr	R0 .. R1 	data		relative address
	# CJNE	Rn, #data, rel		10111rrr dddddddd rrrrrrrr	R0 .. R7 	data		relative address

    $addr = $address + $instr_size + expand_offset($rom[$address + 2]);
    add_jump_label($addr, EMPTY);
    }
  elsif ($instr_mask2 == 0xD8)
    {
	# DJNZ	Rn, rel			11011rrr rrrrrrrr		R0 .. R7	relative address

    $addr = $address + $instr_size + expand_offset($rom[$address + 1]);
    add_jump_label($addr, EMPTY);
    }
  elsif ($instr == 0x02)
    {
	# LJMP	addr16			00000010 aaaaaaaa aaaaaaaa	a15-a8 a7-a0	absolute address

    $addr = ($rom[$address + 1] << 8) | $rom[$address + 2];
    add_jump_label($addr, $address);
    }
  elsif ($instr == 0x12)
    {
	# LCALL	addr16			00010010 aaaaaaaa aaaaaaaa	a15-a8 a7-a0	absolute address

    $addr = ($rom[$address + 1] << 8) | $rom[$address + 2];
    add_func_label($addr);
    }
  elsif ($instr == 0x10 || $instr == 0x20 ||
	 $instr == 0x30 || $instr == 0xB4 ||
	 $instr == 0xB5 || $instr == 0xD5)
    {
	# JBC	bit, rel		00010000 bbbbbbbb rrrrrrrr	bit address		relative address
	# JB	bit, rel		00100000 bbbbbbbb rrrrrrrr	bit address		relative address
	# JNB	bit, rel		00110000 bbbbbbbb rrrrrrrr	bit address		relative address
	# CJNE	A, #data, rel		10110100 dddddddd rrrrrrrr	data			relative address
	# CJNE	A, direct, rel		10110101 aaaaaaaa rrrrrrrr	register address	relative address
	# DJNZ	direct, rel		11010101 aaaaaaaa rrrrrrrr	register address	relative address

    $addr = $address + $instr_size + expand_offset($rom[$address + 2]);
    add_jump_label($addr, EMPTY);
    }
  elsif ($instr == 0x40 || $instr == 0x50 ||
	 $instr == 0x60 || $instr == 0x70 ||
	 $instr == 0x80)
    {
	# JC	rel			01000000 rrrrrrrr 		relative address
	# JNC	rel			01010000 rrrrrrrr 		relative address
	# JZ	rel			01100000 rrrrrrrr 		relative address
	# JNZ	rel			01110000 rrrrrrrr 		relative address
	# SJMP	rel			10000000 rrrrrrrr		relative address

    $addr = $address + $instr_size + expand_offset($rom[$address + 1]);
    add_jump_label($addr, EMPTY);
    }
  }

#-------------------------------------------------------------------------------

	#
	# If exists a variable name wich belong to the $Address, then returns it.
	# Otherwise, returns the address.
	#

sub regname($$)
  {
  my ($Address, $StrRef) = @_;
  my $str;

  if ($Address <= 0x1F)
    {
	# This register belongs to one of the register bank.

    my $bank = ($Address >> 3) & 3;
    my $reg  = $Address & 7;

    $str = ($gen_assembly_code) ? sprintf("0x%02X", $Address) : "R${reg}<#$bank>";
    $$StrRef = $str;

    if (defined($variables_by_address{$Address}))
      {
      my $var = $variables_by_address{$Address};

      printf STDERR ("This address (0x%02X) belongs to two names: \"$str\" and \"$var\"\n", $Address);
      }
    }
  elsif (defined($sfrs_by_address{$Address}))
    {
    $str = $sfrs_by_address{$Address};
    $$StrRef = $str;
    }
  elsif (defined($variables_by_address{$Address}))
    {
    $str = sprintf "0x%02X", $Address;
    $$StrRef = "[$str]";
    $str = $variables_by_address{$Address};
    }
  else
    {
    $str = sprintf "0x%02X", $Address;
    $$StrRef = "[$str]";
    }

  return $str;
  }

#-------------------------------------------------------------------------------

	#
	# If exists a bit name wich belong to the $Address, then returns it.
	# Otherwise, returns the address.
	#

sub bitname($$)
  {
  my ($Address, $StrRef) = @_;
  my $str;

  if (defined($bits_by_address{$Address}))
    {
    $str = $bits_by_address{$Address};
    $$StrRef = $str;
    }
  else
    {
    $str = sprintf "0x%02X", $Address;
    $$StrRef = "[$str]";
    }

  return $str;
  }

#-------------------------------------------------------------------------------

	#
	# If exists a label name wich belong to the $Address, then returns it.
	# Otherwise, returns the address.
	#

sub labelname($)
  {
  my $Address = $_[0];

  return (defined($labels_by_address{$Address})) ? $labels_by_address{$Address}->{NAME} : (sprintf "0x%04X", $Address);
  }

#-------------------------------------------------------------------------------

	#
	# Auxiliary procedure of prints.
	#

sub print_3($$$)
  {
  if ($no_explanations)
    {
    print(($_[1] ne '') ? "$_[0]\t$_[1]\n" : "$_[0]\n");
    }
  else
    {
    print "$_[0]\t" . align($_[1], ALIGN_SIZE) . "; $_[2]\n";
    }
  }

#-------------------------------------------------------------------------------

	#
	# Invalidates the DPTR and the Rx registers.
	#

sub invalidate_DPTR_Rx()
  {
  $DPTR = EMPTY;
  @R_regs[0 .. 7] = ((EMPTY) x 8);
  }

#-------------------------------------------------------------------------------

	#
	# Invalidates the DPTR or the Rx registers.
	#

sub invalidate_reg($)
  {
  my $Address = $_[0];

  if ($Address == DPL || $Address == DPH)
    {
    $DPTR = EMPTY;
    }
  elsif ($Address <= 0x1F)
    {
    $R_regs[$Address & 7] = EMPTY;
    }
  }

#-------------------------------------------------------------------------------

	#
	# Carries out the operations with the R registers.
	#

use constant Rx_INV => 0;
use constant Rx_INC => 1;
use constant Rx_DEC => 2;
use constant Rx_MOV => 3;

sub operation_R_reg
  {
  my $Rx   = shift(@_);
  my $Oper = shift(@_);
  my $r;

  if ($Oper == Rx_INV)
    {
    $R_regs[$Rx] = EMPTY;
    }
  elsif ($Oper == Rx_INC)
    {
    $r = $R_regs[$Rx];

    if ($r != EMPTY)
      {
      ++$r;
      $R_regs[$Rx] = $r & 0xFF;
      return TRUE;
      }
    }
  elsif ($Oper == Rx_DEC)
    {
    $r = $R_regs[$Rx];

    if ($r != EMPTY)
      {
      --$r;
      $R_regs[$Rx] = $r & 0xFF;
      return TRUE;
      }
    }
  elsif ($Oper == Rx_MOV)
    {
    $R_regs[$Rx] = shift(@_) & 0xFF;
    return TRUE;
    }

  return FALSE;
  }

#-------------------------------------------------------------------------------

	#
	# If possible, returns the character.
	#

sub present_char($)
  {
  my $Ch = $_[0];

  if ($Ch >= ord(' ') && $Ch < 0x7F)
    {
    return sprintf " ('%c')", $Ch;
    }
  elsif (defined($control_characters{$Ch}))
    {
    return " ('" . $control_characters{$Ch} . "')";
    }

  return '';
  }

#-------------------------------------------------------------------------------

	#
	# Decodes value of the $Ch.
	#

sub decode_char($)
  {
  my $Ch = $_[0];

  if ($Ch >= ord(' ') && $Ch < 0x7F)
    {
    return sprintf "'%c'", $Ch;
    }
  elsif (defined($control_characters{$Ch}))
    {
    return "'" . $control_characters{$Ch} . "'";
    }

  return sprintf "0x%02X", $Ch;
  }

#   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@@@@@@@@                                   @@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@@@@@@@   These the instruction decoders.   @@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@@@@@@@@                                   @@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 

sub ajmp()
  {
  my ($addr, $rb0, $rb1, $name0, $str0, $str1);

        # AJMP	addr11			aaa00001 aaaaaaaa		a10 a9 a8 0 0 0 0 1	a7-a0

  $rb1   = (($dcd_instr & 0xE0) << 3) | $dcd_parm0;
  $addr  = (($dcd_address + $dcd_instr_size) & 0xF800) | $rb1;
  $rb0   = labelname($addr);
  $name0 = sprintf "0x%04X", $rb1;
  $str0  = ($dcd_address == $addr) ? ' (endless loop)' : '';
  $str1  = sprintf "0x%04X", $addr;
  print_3('ajmp', $rb0, "Jumps hither: $str1 (PC += $dcd_instr_size, PC(10-0) = $name0)$str0");
  invalidate_DPTR_Rx();
  $prev_is_jump = TRUE;
  }

#-------------------------------------------------------------------------------

sub acall()
  {
  my ($addr, $rb0, $rb1, $str0, $str1);

	# ACALL	addr11			aaa10001 aaaaaaaa		a10 a9 a8 1 0 0 0 1	a7-a0

  $rb1   = (($dcd_instr & 0xE0) << 3) | $dcd_parm0;
  $addr  = (($dcd_address + $dcd_instr_size) & 0xF800) | $rb1;
  $rb0   = labelname($addr);
  $str0  = sprintf "0x%04X", $rb1;
  $str1  = sprintf "0x%04X", $addr;
  print_3('acall', $rb0, "Calls this: $str1 (PC += $dcd_instr_size, [++SP] = PCL, [++SP] = PCH, PC(10-0) = $str0)");
  invalidate_DPTR_Rx();
  }

#-------------------------------------------------------------------------------

sub inc_ind_Ri()
  {
	# INC	@Ri			0000011i			R0 .. R1

  print_3('inc', "\@$dcd_Ri_name", "++[$dcd_Ri_name]");
  invalidate_DPTR_Rx();
  }

#-------------------------------------------------------------------------------

sub dec_ind_Ri()
  {
	# DEC	@Ri			0001011i			R0 .. R1

  print_3('dec', "\@$dcd_Ri_name", "--[$dcd_Ri_name]");
  invalidate_DPTR_Rx();
  }

#-------------------------------------------------------------------------------

sub add_A_ind_Ri()
  {
	# ADD	A, @Ri			0010011i			R0 .. R1

  print_3('add', "A, \@$dcd_Ri_name", "ACC += [$dcd_Ri_name]");
  }

#-------------------------------------------------------------------------------

sub addc_A_ind_Ri()
  {
	# ADDC	A, @Ri			0011011i			R0 .. R1

  print_3('addc', "A, \@$dcd_Ri_name", "ACC += [$dcd_Ri_name] + CY");
  }

#-------------------------------------------------------------------------------

sub orl_A_ind_Ri()
  {
	# ORL	A, @Ri			0100011i			R0 .. R1

  print_3('orl', "A, \@$dcd_Ri_name", "ACC |= [$dcd_Ri_name]");
  }

#-------------------------------------------------------------------------------

sub anl_A_ind_Ri()
  {
	# ANL	A, @Ri			0101011i			R0 .. R1

  print_3('anl', "A, \@$dcd_Ri_name", "ACC &= [$dcd_Ri_name]");
  }

#-------------------------------------------------------------------------------

sub xrl_A_ind_Ri()
  {
	# XRL	A, @Ri			0110011i			R0 .. R1

  print_3('xrl', "A, \@$dcd_Ri_name", "ACC ^= [$dcd_Ri_name]");
  }

#-------------------------------------------------------------------------------

sub mov_ind_Ri_data()
  {
  my ($rb0, $str0);

	# MOV	@Ri, #data		0111011i dddddddd		data

  $rb0  = sprintf "0x%02X", $dcd_parm0;
  $str0 = present_char($dcd_parm0);
  print_3('mov', "\@$dcd_Ri_name, #$rb0", "[$dcd_Ri_name] = $rb0$str0");
  invalidate_DPTR_Rx();
  }

#-------------------------------------------------------------------------------

sub mov_direct_ind_Ri()
  {
  my ($rb0, $name0);

	# MOV	direct, @Ri		1000011i aaaaaaaa		R0 .. R1	register address

  $rb0 = regname($dcd_parm0, \$name0);
  print_3('mov', "$rb0, \@$dcd_Ri_name", "$name0 = [$dcd_Ri_name]");
  invalidate_DPTR_Rx();
  }

#-------------------------------------------------------------------------------

sub subb_A_ind_Ri()
  {
	# SUBB	A, @Ri			1001011i			R0 .. R1

  print_3('subb', "A, \@$dcd_Ri_name", "ACC -= [$dcd_Ri_name] + CY");
  }

#-------------------------------------------------------------------------------

sub mov_ind_Ri_direct()
  {
  my ($rb0, $name0);

	# MOV	@Ri, direct		1010011i aaaaaaaa		register address

  $rb0 = regname($dcd_parm0, \$name0);
  print_3('mov', "\@$dcd_Ri_name, $rb0", "[$dcd_Ri_name] = $name0");
  invalidate_DPTR_Rx();
  }

#-------------------------------------------------------------------------------

sub cjne_ind_Ri_data()
  {
  my ($addr, $rb0, $str0, $str1);

	# CJNE	@Ri, #data, rel		1011011i dddddddd rrrrrrrr	R0 .. R1 	data		relative address

  $addr = $dcd_address + $dcd_instr_size + expand_offset($dcd_parm1);
  $rb0  = labelname($addr);
  $str0 = sprintf "0x%02X", $dcd_parm0;
  $str1 = sprintf "0x%04X", $addr;
  print_3('cjne', "\@$dcd_Ri_name, #$str0, $rb0", "If ([$dcd_Ri_name] != $str0) then jumps hither: $str1");
  invalidate_DPTR_Rx();
  $prev_is_jump = TRUE;
  }

#-------------------------------------------------------------------------------

sub xch_A_ind_Ri()
  {
	# XCH	A, @Ri			1100011i			R0 .. R1

  print_3('xch', "A, \@$dcd_Ri_name", "ACC <-> [$dcd_Ri_name]");
  invalidate_DPTR_Rx();
  }

#-------------------------------------------------------------------------------

sub xchd_A_ind_Ri()
  {
	# XCHD	A, @Ri			1101011i			R0 .. R1

  print_3('xchd', "A, \@$dcd_Ri_name", "ACC(3-0) <-> [$dcd_Ri_name](3-0)");
  invalidate_DPTR_Rx();
  }

#-------------------------------------------------------------------------------

sub movx_A_ind_Ri()
  {
	# MOVX	A, @Ri			1110001i			R0 .. R1

  print_3('movx', "A, \@$dcd_Ri_name", "ACC = XRAM[$dcd_Ri_name]");
  }

#-------------------------------------------------------------------------------

sub mov_A_ind_Ri()
  {
	# MOV	A, @Ri			1110011i			R0 .. R1

  print_3('mov', "A, \@$dcd_Ri_name", "ACC = [$dcd_Ri_name]");
  }

#-------------------------------------------------------------------------------

sub movx_ind_Ri_A()
  {
	# MOVX	@Ri, A			1111001i			R0 .. R1

  print_3('movx', "\@$dcd_Ri_name, A", "XRAM[$dcd_Ri_name] = ACC");
  invalidate_DPTR_Rx();
  }

#-------------------------------------------------------------------------------

sub mov_ind_Ri_A()
  {
	# MOV	@Ri, A			1111011i			R0 .. R1

  print_3('mov', "\@$dcd_Ri_name, A", "[$dcd_Ri_name] = ACC");
  invalidate_DPTR_Rx();
  }

#-------------------------------------------------------------------------------

sub inc_Rn()
  {
  my $str0;

	# INC	Rn			00001rrr			R0 .. R7

  if (operation_R_reg($dcd_Rn_regs, Rx_INC))
    {
    $str0 = sprintf "0x%02X", $R_regs[$dcd_Rn_regs];
    print_3('inc', $dcd_Rn_name, "++$dcd_Rn_name ($str0)");
    }
  else
    {
    print_3('inc', $dcd_Rn_name, "++$dcd_Rn_name");
    }
  }

#-------------------------------------------------------------------------------

sub dec_Rn()
  {
  my $str0;

	# DEC	Rn			00011rrr			R0 .. R7

  if (operation_R_reg($dcd_Rn_regs, Rx_DEC))
    {
    $str0 = sprintf "0x%02X", $R_regs[$dcd_Rn_regs];
    print_3('dec', $dcd_Rn_name, "--$dcd_Rn_name ($str0)");
    }
  else
    {
    print_3('dec', $dcd_Rn_name, "--$dcd_Rn_name");
    }
  }

#-------------------------------------------------------------------------------

sub add_A_Rn()
  {
	# ADD	A, Rn			00101rrr			R0 .. R7

  print_3('add', "A, $dcd_Rn_name", "ACC += $dcd_Rn_name");
  }

#-------------------------------------------------------------------------------

sub addc_A_Rn()
  {
	# ADDC	A, Rn			00111rrr			R0 .. R7

  print_3('addc', "A, $dcd_Rn_name", "ACC += $dcd_Rn_name + CY");
  }

#-------------------------------------------------------------------------------

sub orl_A_Rn()
  {
	# ORL	A, Rn			01001rrr		        R0 .. R7

  print_3('orl', "A, $dcd_Rn_name", "ACC |= $dcd_Rn_name");
  }

#-------------------------------------------------------------------------------

sub anl_A_Rn()
  {
	# ANL	A, Rn			01011rrr			R0 .. R7

  print_3('anl', "A, $dcd_Rn_name", "ACC &= $dcd_Rn_name");
  }

#-------------------------------------------------------------------------------

sub xrl_A_Rn()
  {
	# XRL	A, Rn			01101rrr			R0 .. R7

  print_3('xrl', "A, $dcd_Rn_name", "ACC ^= $dcd_Rn_name");
  }

#-------------------------------------------------------------------------------

sub mov_Rn_data()
  {
  my ($rb0, $str0);

	# MOV	Rn, #data		01111rrr dddddddd		R0 .. R7	data

  $rb0  = sprintf "0x%02X", $dcd_parm0;
  $str0 = present_char($dcd_parm0);
  operation_R_reg($dcd_Rn_regs, Rx_MOV, $dcd_parm0);
  print_3('mov', "$dcd_Rn_name, #$rb0", "$dcd_Rn_name = $rb0$str0");
  }

#-------------------------------------------------------------------------------

sub mov_direct_Rn()
  {
  my ($rb0, $name0);

	# MOV	direct, Rn		10001rrr aaaaaaaa		R0 .. R7	register address

  $rb0 = regname($dcd_parm0, \$name0);
  print_3('mov', "$rb0, $dcd_Rn_name", "$name0 = $dcd_Rn_name");
  invalidate_DPTR_Rx();
  }

#-------------------------------------------------------------------------------

sub subb_A_Rn()
  {
	# SUBB	A, Rn			10011rrr			R0 .. R7

  print_3('subb', "A, $dcd_Rn_name", "ACC -= $dcd_Rn_name + CY");
  }

#-------------------------------------------------------------------------------

sub mov_Rn_direct()
  {
  my ($rb0, $name0);

	# MOV	Rn, direct		10101rrr aaaaaaaa		R0 .. R7	register address

  $rb0 = regname($dcd_parm0, \$name0);
  operation_R_reg($dcd_Rn_regs, Rx_INV);
  print_3('mov', "$dcd_Rn_name, $rb0", "$dcd_Rn_name = $name0");
  }

#-------------------------------------------------------------------------------

sub cjne_Rn_data()
  {
  my ($addr, $rb0, $str0, $str1);

	# CJNE	Rn, #data, rel		10111rrr dddddddd rrrrrrrr	R0 .. R7 	data		relative address

  $addr = $dcd_address + $dcd_instr_size + expand_offset($dcd_parm1);
  $rb0  = labelname($addr);
  $str0 = sprintf "0x%02X", $dcd_parm0;
  $str1 = sprintf "0x%04X", $addr;
  print_3('cjne', "$dcd_Rn_name, #$str0, $rb0", "If ($dcd_Rn_name != $str0) then jumps hither: $str1");
  invalidate_DPTR_Rx();
  $prev_is_jump = TRUE;
  }

#-------------------------------------------------------------------------------

sub xch_A_Rn()
  {
	# XCH	A, Rn			11001rrr			R0 .. R7

  operation_R_reg($dcd_Rn_regs, Rx_INV);
  print_3('xch', "A, $dcd_Rn_name", "ACC <-> $dcd_Rn_name");
  }

#-------------------------------------------------------------------------------

sub djnz_Rn()
  {
  my ($addr, $rb0, $str0, $str1);

	# DJNZ	Rn, rel			11011rrr rrrrrrrr		R0 .. R7	relative address

  $addr = $dcd_address + $dcd_instr_size + expand_offset($dcd_parm0);
  $rb0  = labelname($addr);
  $str0 = ($dcd_address == $addr) ? ' (waiting loop)' : '';
  $str1 = sprintf "0x%04X", $addr;
  print_3('djnz', "$dcd_Rn_name, $rb0", "If (--$dcd_Rn_name != 0) then jumps hither: $str1$str0");
  invalidate_DPTR_Rx();
  $prev_is_jump = TRUE;
  }

#-------------------------------------------------------------------------------

sub mov_A_Rn()
  {
	# MOV	A, Rn			11101rrr			R0 .. R7

  print_3('mov', "A, $dcd_Rn_name", "ACC = $dcd_Rn_name");
  }

#-------------------------------------------------------------------------------

sub mov_Rn_A()
  {
	# MOV	Rn, A			11111rrr			R0 .. R7

  operation_R_reg($dcd_Rn_regs, Rx_INV);
  print_3('mov', "$dcd_Rn_name, A", "$dcd_Rn_name = ACC");
  }

#-------------------------------------------------------------------------------

sub nop()
  {
	# NOP				00000000
  print "nop\n";
  }

#-------------------------------------------------------------------------------

sub ljmp()
  {
  my ($addr, $rb0, $str0, $str1);

	# LJMP	addr16			00000010 aaaaaaaa aaaaaaaa	a15-a8 a7-a0	absolute address

  $addr = ($dcd_parm0 << 8) | $dcd_parm1;
  $rb0  = labelname($addr);
  $str0 = ($dcd_address == $addr) ? ' (endless loop)' : '';
  $str1 = sprintf "0x%04X", $addr;
  print_3('ljmp', $rb0, "Jumps hither: $str1$str0");
  invalidate_DPTR_Rx();
  $prev_is_jump = TRUE;
  }

#-------------------------------------------------------------------------------

sub rr_A()
  {
	# RR	A			00000011

  print_3('rr', 'A', 'ACC[76543210] = ACC[07654321]');
  }

#-------------------------------------------------------------------------------

sub inc_A()
  {
	# INC	A			00000100

  print_3('inc', 'A', '++ACC');
  }

#-------------------------------------------------------------------------------

sub inc_direct()
  {
  my ($rb0, $name0);

	# INC	direct			00000101 aaaaaaaa		register address

  $rb0 = regname($dcd_parm0, \$name0);
  print_3('inc', $rb0, "++$name0");
  invalidate_reg($dcd_parm0);
  }

#-------------------------------------------------------------------------------

sub jbc_bit()
  {
  my ($addr, $rb0, $rb1, $name0, $str0);

	# JBC	bit, rel		00100000 bbbbbbbb rrrrrrrr	bit address		relative address

  $addr = $dcd_address + $dcd_instr_size + expand_offset($dcd_parm1);
  $rb0  = bitname($dcd_parm0, \$name0);
  $rb1  = labelname($addr);
  $str0 = sprintf "0x%04X", $addr;
  print_3('jbc', "$rb0, $rb1", "If ($name0 == H) then $name0 = L and jumps hither: $str0");
  invalidate_DPTR_Rx();
  $prev_is_jump = TRUE;
  }

#-------------------------------------------------------------------------------

sub lcall()
  {
  my ($addr, $rb0, $str0);

	# LCALL	addr16			00010010 aaaaaaaa aaaaaaaa	a15-a8 a7-a0	absolute address

  $addr = ($dcd_parm0 << 8) | $dcd_parm1;
  $rb0  = labelname($addr);
  $str0 = sprintf "0x%04X", $addr;
  print_3('lcall', $rb0, "Calls this: $str0 (PC += $dcd_instr_size, [++SP] = PCL, [++SP] = PCH, PC = $str0)");
  invalidate_DPTR_Rx();
  }

#-------------------------------------------------------------------------------

sub rrc_A()
  {
	# RRC	A			00010011

  print_3('rrc', 'A', 'ACC[76543210] = ACC[C7654321], CY = ACC[0]');
  }

#-------------------------------------------------------------------------------

sub dec_A()
  {
	# DEC	A			00010100

  print_3('dec', 'A', '--ACC');
  }

#-------------------------------------------------------------------------------

sub dec_direct()
  {
  my ($rb0, $name0);

	# DEC	direct			00010101 aaaaaaaa		register address

  $rb0 = regname($dcd_parm0, \$name0);
  print_3('dec', $rb0, "--$name0");
  invalidate_reg($dcd_parm0);
  }

#-------------------------------------------------------------------------------

sub jb_bit()
  {
  my ($addr, $rb0, $rb1, $name0, $str0, $str1);

	# JB	bit, rel		00100000 bbbbbbbb rrrrrrrr	bit address		relative address

  $addr = $dcd_address + $dcd_instr_size + expand_offset($dcd_parm1);
  $rb0  = bitname($dcd_parm0, \$name0);
  $rb1  = labelname($addr);
  $str0 = ($dcd_address == $addr) ? ' (waiting loop)' : '';
  $str1 = sprintf "0x%04X", $addr;
  print_3('jb', "$rb0, $rb1", "If ($name0 == H) then jumps hither: $str1$str0");
  invalidate_DPTR_Rx();
  $prev_is_jump = TRUE;
  }

#-------------------------------------------------------------------------------

sub ret()
  {
	# RET				00100010

  print_3('ret', '', 'PCH = [SP--], PCL = [SP--]');
  invalidate_DPTR_Rx();
  $prev_is_jump = TRUE;
  }

#-------------------------------------------------------------------------------

sub rl_A()
  {
	# RL	A			00100011

  print_3('rl', 'A', 'ACC[76543210] = ACC[65432107]');
  }

#-------------------------------------------------------------------------------

sub add_A_data()
  {
  my ($rb0, $str0);

	# ADD	A, #data		00100100 dddddddd		data

  $rb0  = sprintf "0x%02X", $dcd_parm0;
  $str0 = present_char($dcd_parm0);
  print_3('add', "A, #$rb0", "ACC += $rb0$str0");
  }

#-------------------------------------------------------------------------------

sub add_A_direct()
  {
  my ($rb0, $name0);

	# ADD	A, direct		00100101 aaaaaaaa		register address

  $rb0 = regname($dcd_parm0, \$name0);
  print_3('add', "A, $rb0", "ACC += $name0");
  }

#-------------------------------------------------------------------------------

sub jnb_bit()
  {
  my ($addr, $rb0, $rb1, $name0, $str0, $str1);

	# JNB	bit, rel		00110000 bbbbbbbb rrrrrrrr	bit address		relative address

  $addr = $dcd_address + $dcd_instr_size + expand_offset($dcd_parm1);
  $rb0  = bitname($dcd_parm0, \$name0);
  $rb1  = labelname($addr);
  $str0 = ($dcd_address == $addr) ? ' (waiting loop)' : '';
  $str1 = sprintf "0x%04X", $addr;
  print_3('jnb', "$rb0, $rb1", "If ($name0 == L) then jumps hither: $str1$str0");
  invalidate_DPTR_Rx();
  $prev_is_jump = TRUE;
  }

#-------------------------------------------------------------------------------

sub reti()
  {
	# RETI				00110010

  print_3('reti', '', 'PCH = [SP--], PCL = [SP--]');
  invalidate_DPTR_Rx();
  $prev_is_jump = TRUE;
  }

#-------------------------------------------------------------------------------

sub rcl_A()
  {
	# RLC	A			00110011

  print_3('rlc', 'A', 'ACC[76543210] = ACC[6543210C], CY = ACC[7]');
  }

#-------------------------------------------------------------------------------

sub addc_A_data()
  {
  my ($rb0, $str0);

	# ADDC	A, #data		00110100 dddddddd		data

  $rb0  = sprintf "0x%02X", $dcd_parm0;
  $str0 = present_char($dcd_parm0);
  print_3('addc', "A, #$rb0", "ACC += $rb0 + CY$str0");
  }

#-------------------------------------------------------------------------------

sub addc_A_direct()
  {
  my ($rb0, $name0);

	# ADDC	A, direct		00110101 aaaaaaaa		register address

  $rb0 = regname($dcd_parm0, \$name0);
  print_3('addc', "A, $rb0", "ACC += $name0 + CY");
  }

#-------------------------------------------------------------------------------

sub jc()
  {
  my ($addr, $rb0, $str0);

	# JC	rel			01000000 rrrrrrrr 		relative address

  $addr = $dcd_address + $dcd_instr_size + expand_offset($dcd_parm0);
  $rb0  = labelname($addr);
  $str0 = sprintf "0x%04X", $addr;
  print_3('jc', $rb0, "If (CY == H) then jumps hither: $str0");
  invalidate_DPTR_Rx();
  $prev_is_jump = TRUE;
  }

#-------------------------------------------------------------------------------

sub orl_direct_A()
  {
  my ($rb0, $name0);

	# ORL	direct, A		01000010 aaaaaaaa		register address

  $rb0 = regname($dcd_parm0, \$name0);
  print_3('orl', "$rb0, A", "$name0 |= ACC");
  invalidate_reg($dcd_parm0);
  }

#-------------------------------------------------------------------------------

sub orl_direct_data()
  {
  my ($rb0, $rb1, $name0, $str0);

	# ORL	direct, #data		01000011 aaaaaaaa dddddddd	register address	data

  $rb0  = regname($dcd_parm0, \$name0);
  $rb1  = sprintf "0x%02X", $dcd_parm1;
  $str0 = present_char($dcd_parm1);
  print_3('orl', "$rb0, #$rb1", "$name0 |= $rb1$str0");
  invalidate_reg($dcd_parm0);
  }

#-------------------------------------------------------------------------------

sub orl_A_data()
  {
  my ($rb0, $str0);

	# ORL	A, #data		01000100 dddddddd		data

  $rb0  = sprintf "0x%02X", $dcd_parm0;
  $str0 = present_char($dcd_parm0);
  print_3('orl', "A, #$rb0", "ACC |= $rb0$str0");
  }

#-------------------------------------------------------------------------------

sub orl_A_direct()
  {
  my ($rb0, $name0);

	# ORL	A, direct		01000101 aaaaaaaa		register address

  $rb0 = regname($dcd_parm0, \$name0);
  print_3('orl', "A, $rb0", "ACC |= $name0");
  }

#-------------------------------------------------------------------------------

sub jnc()
  {
  my ($addr, $rb0, $str0);

	# JNC	rel			01010000 rrrrrrrr 		relative address

  $addr = $dcd_address + $dcd_instr_size + expand_offset($dcd_parm0);
  $rb0  = labelname($addr);
  $str0 = sprintf "0x%04X", $addr;
  print_3('jnc', $rb0, "If (CY == L) then jumps hither: $str0");
  invalidate_DPTR_Rx();
  $prev_is_jump = TRUE;
  }

#-------------------------------------------------------------------------------

sub anl_direct_A()
  {
  my ($rb0, $name0);

	# ANL	direct, A		01010010 aaaaaaaa		register address

  $rb0 = regname($dcd_parm0, \$name0);
  print_3('anl', "$rb0, A", "$name0 &= ACC");
  invalidate_reg($dcd_parm0);
  }

#-------------------------------------------------------------------------------

sub anl_direct_data()
  {
  my ($rb0, $rb1, $name0, $str0);

	# ANL	direct, #data		01010011 aaaaaaaa dddddddd	register address	data

  $rb0  = regname($dcd_parm0, \$name0);
  $rb1  = sprintf "0x%02X", $dcd_parm1;
  $str0 = present_char($dcd_parm1);
  print_3('anl', "$rb0, #$rb1", "$name0 &= $rb1$str0");
  invalidate_reg($dcd_parm0);
  }

#-------------------------------------------------------------------------------

sub anl_A_data()
  {
  my ($rb0, $str0);

	# ANL	A, #data		01010100 dddddddd		data

  $rb0  = sprintf "0x%02X", $dcd_parm0;
  $str0 = present_char($dcd_parm0);
  print_3('anl', "A, #$rb0", "ACC &= $rb0$str0");
  }

#-------------------------------------------------------------------------------

sub anl_A_direct()
  {
  my ($rb0, $name0);

	# ANL	A, direct		01010101 aaaaaaaa		register address

  $rb0 = regname($dcd_parm0, \$name0);
  print_3('anl', "A, $rb0", "ACC &= $name0");
  }

#-------------------------------------------------------------------------------

sub jz()
  {
  my ($addr, $rb0, $str0);

	# JZ	rel			01100000 rrrrrrrr 		relative address

  $addr = $dcd_address + $dcd_instr_size + expand_offset($dcd_parm0);
  $rb0  = labelname($addr);
  $str0 = sprintf "0x%04X", $addr;
  print_3('jz', $rb0, "If (ACC == 0) then jumps hither: $str0");
  invalidate_DPTR_Rx();
  $prev_is_jump = TRUE;
  }

#-------------------------------------------------------------------------------

sub xrl_direct_A()
  {
  my ($rb0, $name0);

	# XRL	direct, A		01100010 aaaaaaaa		register address

  $rb0 = regname($dcd_parm0, \$name0);
  print_3('xrl', "$rb0, A", "$name0 ^= ACC");
  invalidate_reg($dcd_parm0);
  }

#-------------------------------------------------------------------------------

sub xrl_direct_data()
  {
  my ($rb0, $rb1, $name0, $str0);

	# XRL	direct, #data		01100011 aaaaaaaa dddddddd	register address	data

  $rb0  = regname($dcd_parm0, \$name0);
  $rb1  = sprintf "0x%02X", $dcd_parm1;
  $str0 = present_char($dcd_parm1);
  print_3('xrl', "$rb0, #$rb1", "$name0 |= $rb1$str0");
  invalidate_reg($dcd_parm0);
  }

#-------------------------------------------------------------------------------

sub xrl_A_data()
  {
  my ($rb0, $str0);

	# XRL	A, #data		01100100 dddddddd		data

  $rb0  = sprintf "0x%02X", $dcd_parm0;
  $str0 = present_char($dcd_parm0);
  print_3('xrl', "A, #$rb0", "ACC ^= $rb0$str0");
  }

#-------------------------------------------------------------------------------

sub xrl_A_direct()
  {
  my ($rb0, $name0);

	# XRL	A, direct		01100101 aaaaaaaa		register address

  $rb0 = regname($dcd_parm0, \$name0);
  print_3('xrl', "A, $rb0", "ACC |= $name0");
  }

#-------------------------------------------------------------------------------

sub jnz()
  {
  my ($addr, $rb0, $str0);

	# JNZ	rel			01110000 rrrrrrrr 		relative address

  $addr = $dcd_address + $dcd_instr_size + expand_offset($dcd_parm0);
  $rb0  = labelname($addr);
  $str0 = sprintf "0x%04X", $addr;
  print_3('jnz', $rb0, "If (ACC != 0) then jumps hither: $str0");
  invalidate_DPTR_Rx();
  $prev_is_jump = TRUE;
  }

#-------------------------------------------------------------------------------

sub orl_C_bit()
  {
  my ($rb0, $name0);

	# ORL	C, bit			01110010 bbbbbbbb		bit address

  $rb0 = bitname($dcd_parm0, \$name0);
  print_3('orl', "C, $rb0", "CY |= $name0");
  }

#-------------------------------------------------------------------------------

sub jmp_A_DPTR()
  {
	# JMP	@A+DPTR			01110011

  print_3('jmp', '@A+DPTR', "Jumps hither: [DPTR + ACC]\n");
  invalidate_DPTR_Rx();
  $prev_is_jump = TRUE;
  }

#-------------------------------------------------------------------------------

sub mov_A_data()
  {
  my ($rb0, $str0);

	# MOV	A, #data		01110100 dddddddd		data

  $rb0  = sprintf "0x%02X", $dcd_parm0;
  $str0 = present_char($dcd_parm0);
  print_3('mov', "A, #$rb0", "ACC = $rb0$str0");
  }

#-------------------------------------------------------------------------------

sub mov_direct_data()
  {
  my ($rb0, $rb1, $name0, $str0, $str1);

	# MOV	direct, #data		01110101 aaaaaaaa dddddddd	register address	data

  $rb0  = regname($dcd_parm0, \$name0);
  $rb1  = sprintf "0x%02X", $dcd_parm1;
  $str0 = '';
  $str1 = sprintf "%02X", $dcd_parm0;

  if ($dcd_parm0 == PSW)
    {
    $str0 = sprintf(" (select bank #%u)", ($dcd_parm1 >> 3) & 0x03) if (($dcd_parm1 & ~0x18) == 0x00);
    }
  else
    {
    $str0 = present_char($dcd_parm1);
    }

  print_3('mov', "$rb0, #$rb1", "$name0 = $rb1$str0");
  invalidate_reg($dcd_parm0);
  }

#-------------------------------------------------------------------------------

sub sjmp()
  {
  my ($addr, $rb0, $rb1, $name0, $name1, $str0, $str1);

	# SJMP	rel			10000000 rrrrrrrr		relative address

  $addr = $dcd_address + $dcd_instr_size + expand_offset($dcd_parm0);
  $rb0  = labelname($addr);
  $str0 = ($dcd_address == $addr) ? ' (endless loop)' : '';
  $str1 = sprintf "0x%04X", $addr;
  print_3('sjmp', $rb0, "Jumps hither: $str1$str0");
  invalidate_DPTR_Rx();
  $prev_is_jump = TRUE;
  }

#-------------------------------------------------------------------------------

sub anl_C_bit()
  {
  my ($rb0, $name0);

	# ANL	C, bit			10000010 bbbbbbbb		bit address

  $rb0 = bitname($dcd_parm0, \$name0);
  print_3('anl', "C, $rb0", "CY &= $name0");
  }

#-------------------------------------------------------------------------------

sub movc_A_A_PC()
  {
	# MOVC	A, @A+PC		10000011

  print_3('movc', 'A, @A+PC', "ACC = ROM[PC + $dcd_instr_size + ACC]");
  }

#-------------------------------------------------------------------------------

sub div_AB()
  {
	# DIV	AB			10000100

  print_3('div', 'AB', 'ACC = ACC / B, B = ACC % B');
  }

#-------------------------------------------------------------------------------

sub mov_direct_direct()
  {
  my ($rb0, $rb1, $name0, $name1);

	# MOV	direct, direct		10000101 aaaaaaaa aaaaaaaa	forrás reg.	cél reg.

  $rb0 = regname($dcd_parm0, \$name0);
  $rb1 = regname($dcd_parm1, \$name1);
  print_3('mov', "$rb1, $rb0", "$name1 = $name0");
  invalidate_reg($dcd_parm0);
  }

#-------------------------------------------------------------------------------

sub mov_DPTR_data()
  {
  my ($addr, $str0);

	# MOV	DPTR, #data16		10010000 dddddddd dddddddd	d15-d8 d7-d0

  $addr = ($dcd_parm0 << 8) | $dcd_parm1;
  $str0 = sprintf "0x%04X", $addr;
  print_3('mov', "DPTR, #$str0", "DPTR = $str0");
  $DPTR = $addr;
  }

#-------------------------------------------------------------------------------

sub mov_bit_C()
  {
  my ($rb0, $name0);

	# MOV	bit, C			10010010 bbbbbbbb		bit address

  $rb0 = bitname($dcd_parm0, \$name0);
  print_3('mov', "$rb0, C", "$name0 = CY");
  }

#-------------------------------------------------------------------------------

sub movc_A_A_DPTR()
  {
	# MOVC	A, @A+DPTR		10010011

  print_3('movc', 'A, @A+DPTR', 'ACC = ROM[DPTR + ACC]');
  }

#-------------------------------------------------------------------------------

sub subb_A_data()
  {
  my ($rb0, $str0);

	# SUBB	A, #data		10010100 dddddddd		data

  $rb0  = sprintf "0x%02X", $dcd_parm0;
  $str0 = present_char($dcd_parm0);
  print_3('subb', "A, #$rb0", "ACC -= $rb0 + CY$str0");
  }

#-------------------------------------------------------------------------------

sub subb_A_direct()
  {
  my ($rb0, $name0);

	# SUBB	A, direct		10010101 aaaaaaaa		register address

  $rb0 = regname($dcd_parm0, \$name0);
  print_3('subb', "A, $rb0", "ACC -= $name0 + CY");
  }

#-------------------------------------------------------------------------------

sub orl_C__bit()
  {
  my ($rb0, $name0);

	# ORL	C, /bit			10100000 bbbbbbbb		bit address

  $rb0 = bitname($dcd_parm0, \$name0);
  print_3('orl', "C, /$rb0", "CY = ~$name0");
  }

#-------------------------------------------------------------------------------

sub mov_C_bit()
  {
  my ($rb0, $name0);

	# MOV	C, bit			10100010 bbbbbbbb		bit address

  $rb0 = bitname($dcd_parm0, \$name0);
  print_3('mov', "C, $rb0", "CY = $name0");
  }

#-------------------------------------------------------------------------------

sub inc_DPTR()
  {
  my $str0;

	# INC	DPTR			10100011

  if ($DPTR != EMPTY)
    {
    ++$DPTR;
    $str0 = sprintf " (0x%04X)", $DPTR;
    }
  else
    {
    $str0 = '';
    }

  print_3('inc', 'DPTR', "++DPTR$str0");
  }

#-------------------------------------------------------------------------------

sub mul_AB()
  {
	# MUL	AB			10100100

  print_3('mul', 'AB', 'B:ACC = ACC * B');
  }

#-------------------------------------------------------------------------------

sub unknown()
  {
  my ($rb0, $str0, $str1);

	# The unknown instruction is actually simple embedded data in the code.

  $rb0  = sprintf "0x%02X", $dcd_instr;
  $str0 = present_char($dcd_instr);
  $str1 = sprintf "0x%04X", $dcd_address;
  print_3('.db', $rb0, "$str1: $rb0$str0");
  }

#-------------------------------------------------------------------------------

sub anl_C__bit()
  {
  my ($rb0, $name0);

	# ANL	C, /bit			10110000 bbbbbbbb		bit address

  $rb0 = bitname($dcd_parm0, \$name0);
  print_3('anl', "C, /$rb0", "CY &= ~$name0");
  }

#-------------------------------------------------------------------------------

sub cpl_bit()
  {
  my ($rb0, $name0);

	# CPL	bit			10110010 bbbbbbbb		bit address

  $rb0 = bitname($dcd_parm0, \$name0);
  print_3('cpl', $rb0, "$name0 = ~$name0");
  }

#-------------------------------------------------------------------------------

sub cpl_C()
  {
	# CPL	C			10110011

  print_3('cpl', 'C', 'CY = ~CY');
  }

#-------------------------------------------------------------------------------

sub cjne_A_data()
  {
  my ($addr, $rb0, $rb1, $str0);

	# CJNE	A, #data, rel		10110100 dddddddd rrrrrrrr	data		relative address

  $addr = $dcd_address + $dcd_instr_size + expand_offset($dcd_parm1);
  $rb0  = labelname($addr);
  $rb1  = sprintf "0x%02X", $dcd_parm0;
  $str0 = sprintf "0x%04X", $addr;
  print_3('cjne', "A, #$rb1, $rb0", "If (ACC != $rb1) then jumps hither: $str0");
  invalidate_DPTR_Rx();
  $prev_is_jump = TRUE;
  }

#-------------------------------------------------------------------------------

sub cjne_A_direct()
  {
  my ($addr, $rb0, $rb1, $name0, $str0, $str1);

	# CJNE	A, direct, rel		10110101 aaaaaaaa rrrrrrrr	register address	relative address

  $addr = $dcd_address + $dcd_instr_size + expand_offset($dcd_parm1);
  $rb0  = regname($dcd_parm0, \$name0);
  $rb1  = labelname($addr);
  $str0 = sprintf "0x%04X", $addr;
  $str1 = ($dcd_address == $addr) ? ' (waiting loop)' : '';
  print_3('cjne', "A, $rb0, $rb1", "If (ACC != $name0) then jumps hither: $str0$str1");
  invalidate_DPTR_Rx();
  $prev_is_jump = TRUE;
  }

#-------------------------------------------------------------------------------

sub push_direct()
  {
  my ($rb0, $name0);

	# PUSH	direct			11000000 aaaaaaaa		register address

  $rb0 = regname($dcd_parm0, \$name0);
  print_3('push', $rb0, "++SP, [SP] = $name0");
  }

#-------------------------------------------------------------------------------

sub clr_bit()
  {
  my ($rb0, $name0);

	# CLR	bit			11000010 bbbbbbbb		bit address

  $rb0 = bitname($dcd_parm0, \$name0);
  print_3('clr', $rb0, "$name0 = L");
  }

#-------------------------------------------------------------------------------

sub clr_C()
  {
	# CLR	C			11000011

  print_3('clr', 'C', 'CY = L');
  }

#-------------------------------------------------------------------------------

sub swap_A()
  {
	# SWAP	A			11000100

  print_3('swap', 'A', 'ACC[76543210] = ACC[32107654]');
  }

#-------------------------------------------------------------------------------

sub xch_A_direct()
  {
  my ($rb0, $name0);

	# XCH	A, direct		11000101 aaaaaaaa		register address

  $rb0 = regname($dcd_parm0, \$name0);
  print_3('xch', "A, $rb0", "ACC <-> $name0");
  invalidate_DPTR_Rx();
  }

#-------------------------------------------------------------------------------

sub pop_direct()
  {
  my ($rb0, $name0);

	# POP	direct			11010000 aaaaaaaa		register address

  $rb0 = regname($dcd_parm0, \$name0);
  print_3('pop', $rb0, "$name0 = [SP], --SP");
  invalidate_reg($dcd_parm0);
  }

#-------------------------------------------------------------------------------

sub setb_bit()
  {
  my ($rb0, $name0);

	# SETB	bit			11010010 bbbbbbbb		bit address

  $rb0 = bitname($dcd_parm0, \$name0);
  print_3('setb', $rb0, "$name0 = H");
  }

#-------------------------------------------------------------------------------

sub setb_C()
  {
	# SETB	C			11010011

  print_3('setb', 'C', 'CY = H');
  }

#-------------------------------------------------------------------------------

sub da_A()
  {
	# DA	A			11010100

  print_3('da', 'A', 'Decimal adjust the ACC.');
  }

#-------------------------------------------------------------------------------

sub djnz_direct()
  {
  my ($addr, $rb0, $rb1, $name0, $str0, $str1);

	# DJNZ	direct, rel		11010101 aaaaaaaa rrrrrrrr	register address	relative address

  $addr = $dcd_address + $dcd_instr_size + expand_offset($dcd_parm1);
  $rb0  = regname($dcd_parm0, \$name0);
  $rb1  = labelname($addr);
  $str0 = ($dcd_address == $addr) ? ' (waiting loop)' : '';
  $str1 = sprintf "0x%04X", $addr;
  print_3('djnz', "$rb0, $rb1", "If (--$name0 != 0) then jumps hither: $str1$str0");
  invalidate_DPTR_Rx();
  $prev_is_jump = TRUE;
  }

#-------------------------------------------------------------------------------

sub movx_A_DPTR()
  {
	# MOVX	A, @DPTR		11100000

  print_3('movx', 'A, @DPTR', 'ACC = XRAM[DPTR]');
  }

#-------------------------------------------------------------------------------

sub clr_A()
  {
	# CLR	A			11100100

  print_3('clr', 'A', 'ACC = 0');
  }

#-------------------------------------------------------------------------------

sub mov_A_direct()
  {
  my ($rb0, $name0);

	# MOV	A, direct		11100101 aaaaaaaa		register address	The "MOV A, ACC" invalid instruction.

  $rb0 = regname($dcd_parm0, \$name0);
  print_3('mov', "A, $rb0", "ACC = $name0");
  }

#-------------------------------------------------------------------------------

sub movx_DPTR_A()
  {
	# MOVX	@DPTR, A		11110000

  print_3('movx', '@DPTR, A', 'XRAM[DPTR] = ACC');
  }

#-------------------------------------------------------------------------------

sub cpl_A()
  {
	# CPL	A			11110100

  print_3('cpl', 'A', 'ACC = ~ACC');
  }

#-------------------------------------------------------------------------------

sub mov_direct_A()
  {
  my ($rb0, $name0);

	# MOV	direct, A		11110101 aaaaaaaa		register address

  $rb0 = regname($dcd_parm0, \$name0);
  print_3('mov', "$rb0, A", "$name0 = ACC");
  invalidate_reg($dcd_parm0);
  }

#-------------------------------------------------------------------------------

my @instr_decoders =
  (
	# 0x00 - 0x0F
  \&nop,
  \&ajmp,
  \&ljmp,
  \&rr_A,
  \&inc_A,
  \&inc_direct,
  \&inc_ind_Ri,
  \&inc_ind_Ri,
  \&inc_Rn,
  \&inc_Rn,
  \&inc_Rn,
  \&inc_Rn,
  \&inc_Rn,
  \&inc_Rn,
  \&inc_Rn,
  \&inc_Rn,

	# 0x10 - 0x1F
  \&jbc_bit,
  \&acall,
  \&lcall,
  \&rrc_A,
  \&dec_A,
  \&dec_direct,
  \&dec_ind_Ri,
  \&dec_ind_Ri,
  \&dec_Rn,
  \&dec_Rn,
  \&dec_Rn,
  \&dec_Rn,
  \&dec_Rn,
  \&dec_Rn,
  \&dec_Rn,
  \&dec_Rn,

	# 0x20 - 0x2F
  \&jb_bit,
  \&ajmp,
  \&ret,
  \&rl_A,
  \&add_A_data,
  \&add_A_direct,
  \&add_A_ind_Ri,
  \&add_A_ind_Ri,
  \&add_A_Rn,
  \&add_A_Rn,
  \&add_A_Rn,
  \&add_A_Rn,
  \&add_A_Rn,
  \&add_A_Rn,
  \&add_A_Rn,
  \&add_A_Rn,

	# 0x30 - 0x3F
  \&jnb_bit,
  \&acall,
  \&reti,
  \&rcl_A,
  \&addc_A_data,
  \&addc_A_direct,
  \&addc_A_ind_Ri,
  \&addc_A_ind_Ri,
  \&addc_A_Rn,
  \&addc_A_Rn,
  \&addc_A_Rn,
  \&addc_A_Rn,
  \&addc_A_Rn,
  \&addc_A_Rn,
  \&addc_A_Rn,
  \&addc_A_Rn,

	# 0x40 - 0x4F
  \&jc,
  \&ajmp,
  \&orl_direct_A,
  \&orl_direct_data,
  \&orl_A_data,
  \&orl_A_direct,
  \&orl_A_ind_Ri,
  \&orl_A_ind_Ri,
  \&orl_A_Rn,
  \&orl_A_Rn,
  \&orl_A_Rn,
  \&orl_A_Rn,
  \&orl_A_Rn,
  \&orl_A_Rn,
  \&orl_A_Rn,
  \&orl_A_Rn,

	# 0x50 - 0x5F
  \&jnc,
  \&acall,
  \&anl_direct_A,
  \&anl_direct_data,
  \&anl_A_data,
  \&anl_A_direct,
  \&anl_A_ind_Ri,
  \&anl_A_ind_Ri,
  \&anl_A_Rn,
  \&anl_A_Rn,
  \&anl_A_Rn,
  \&anl_A_Rn,
  \&anl_A_Rn,
  \&anl_A_Rn,
  \&anl_A_Rn,
  \&anl_A_Rn,

	# 0x60 - 0x6F
  \&jz,
  \&ajmp,
  \&xrl_direct_A,
  \&xrl_direct_data,
  \&xrl_A_data,
  \&xrl_A_direct,
  \&xrl_A_ind_Ri,
  \&xrl_A_ind_Ri,
  \&xrl_A_Rn,
  \&xrl_A_Rn,
  \&xrl_A_Rn,
  \&xrl_A_Rn,
  \&xrl_A_Rn,
  \&xrl_A_Rn,
  \&xrl_A_Rn,
  \&xrl_A_Rn,

	# 0x70 - 0x7F
  \&jnz,
  \&acall,
  \&orl_C_bit,
  \&jmp_A_DPTR,
  \&mov_A_data,
  \&mov_direct_data,
  \&mov_ind_Ri_data,
  \&mov_ind_Ri_data,
  \&mov_Rn_data,
  \&mov_Rn_data,
  \&mov_Rn_data,
  \&mov_Rn_data,
  \&mov_Rn_data,
  \&mov_Rn_data,
  \&mov_Rn_data,
  \&mov_Rn_data,

	# 0x80 - 0x8F
  \&sjmp,
  \&ajmp,
  \&anl_C_bit,
  \&movc_A_A_PC,
  \&div_AB,
  \&mov_direct_direct,
  \&mov_direct_ind_Ri,
  \&mov_direct_ind_Ri,
  \&mov_direct_Rn,
  \&mov_direct_Rn,
  \&mov_direct_Rn,
  \&mov_direct_Rn,
  \&mov_direct_Rn,
  \&mov_direct_Rn,
  \&mov_direct_Rn,
  \&mov_direct_Rn,

	# 0x90 - 0x9F
  \&mov_DPTR_data,
  \&acall,
  \&mov_bit_C,
  \&movc_A_A_DPTR,
  \&subb_A_data,
  \&subb_A_direct,
  \&subb_A_ind_Ri,
  \&subb_A_ind_Ri,
  \&subb_A_Rn,
  \&subb_A_Rn,
  \&subb_A_Rn,
  \&subb_A_Rn,
  \&subb_A_Rn,
  \&subb_A_Rn,
  \&subb_A_Rn,
  \&subb_A_Rn,

	# 0xA0 - 0xAF
  \&orl_C__bit,
  \&ajmp,
  \&mov_C_bit,
  \&inc_DPTR,
  \&mul_AB,
  \&unknown,
  \&mov_ind_Ri_direct,
  \&mov_ind_Ri_direct,
  \&mov_Rn_direct,
  \&mov_Rn_direct,
  \&mov_Rn_direct,
  \&mov_Rn_direct,
  \&mov_Rn_direct,
  \&mov_Rn_direct,
  \&mov_Rn_direct,
  \&mov_Rn_direct,

	# 0xB0 - 0xBF
  \&anl_C__bit,
  \&acall,
  \&cpl_bit,
  \&cpl_C,
  \&cjne_A_data,
  \&cjne_A_direct,
  \&cjne_ind_Ri_data,
  \&cjne_ind_Ri_data,
  \&cjne_Rn_data,
  \&cjne_Rn_data,
  \&cjne_Rn_data,
  \&cjne_Rn_data,
  \&cjne_Rn_data,
  \&cjne_Rn_data,
  \&cjne_Rn_data,
  \&cjne_Rn_data,

	# 0xC0 - 0xCF
  \&push_direct,
  \&ajmp,
  \&clr_bit,
  \&clr_C,
  \&swap_A,
  \&xch_A_direct,
  \&xch_A_ind_Ri,
  \&xch_A_ind_Ri,
  \&xch_A_Rn,
  \&xch_A_Rn,
  \&xch_A_Rn,
  \&xch_A_Rn,
  \&xch_A_Rn,
  \&xch_A_Rn,
  \&xch_A_Rn,
  \&xch_A_Rn,

	# 0xD0 - 0xDF
  \&pop_direct,
  \&acall,
  \&setb_bit,
  \&setb_C,
  \&da_A,
  \&djnz_direct,
  \&xchd_A_ind_Ri,
  \&xchd_A_ind_Ri,
  \&djnz_Rn,
  \&djnz_Rn,
  \&djnz_Rn,
  \&djnz_Rn,
  \&djnz_Rn,
  \&djnz_Rn,
  \&djnz_Rn,
  \&djnz_Rn,

	# 0xE0 - 0xEF
  \&movx_A_DPTR,
  \&ajmp,
  \&movx_A_ind_Ri,
  \&movx_A_ind_Ri,
  \&clr_A,
  \&mov_A_direct,
  \&mov_A_ind_Ri,
  \&mov_A_ind_Ri,
  \&mov_A_Rn,
  \&mov_A_Rn,
  \&mov_A_Rn,
  \&mov_A_Rn,
  \&mov_A_Rn,
  \&mov_A_Rn,
  \&mov_A_Rn,
  \&mov_A_Rn,

	# 0xF0 - 0xFF
  \&movx_DPTR_A,
  \&acall,
  \&movx_ind_Ri_A,
  \&movx_ind_Ri_A,
  \&cpl_A,
  \&mov_direct_A,
  \&mov_ind_Ri_A,
  \&mov_ind_Ri_A,
  \&mov_Rn_A,
  \&mov_Rn_A,
  \&mov_Rn_A,
  \&mov_Rn_A,
  \&mov_Rn_A,
  \&mov_Rn_A,
  \&mov_Rn_A,
  \&mov_Rn_A
  );

#-------------------------------------------------------------------------------

        #
        # Decodes the $BlockRef.
        #

sub instruction_decoder($)
  {
  my $BlockRef = $_[0];

  $dcd_address    = $BlockRef->{ADDR};
  $dcd_instr_size = $BlockRef->{SIZE};
  $dcd_instr      = $rom[$dcd_address];

  printf("0x%04X: %02X", $dcd_address, $dcd_instr) if (! $gen_assembly_code);

  if ($dcd_instr_size == 1)
    {
    print(($gen_assembly_code) ? "\t" : "\t\t");
    }
  elsif ($dcd_instr_size == 2)
    {
    $dcd_parm0 = $rom[$dcd_address + 1];

    if ($gen_assembly_code)
      {
      print "\t";
      }
    else
      {
      printf " %02X\t\t", $dcd_parm0;
      }
    }
  elsif ($dcd_instr_size == 3)
    {
    $dcd_parm0 = $rom[$dcd_address + 1];
    $dcd_parm1 = $rom[$dcd_address + 2];

    if ($gen_assembly_code)
      {
      print "\t";
      }
    else
      {
      printf " %02X %02X\t", $dcd_parm0, $dcd_parm1;
      }
    }
  else
    {
    print "\t";
    }

  $dcd_Ri_regs = $dcd_instr & 0x01;
  $dcd_Ri_name = "R$dcd_Ri_regs";

  $dcd_Rn_regs = $dcd_instr & 0x07;
  $dcd_Rn_name = "R$dcd_Rn_regs";

  $prev_is_jump = FALSE;

  if ($dcd_instr != EMPTY)
    {
    $instr_decoders[$dcd_instr]();
    }
  else
    {
    unknown();
    }
  }

#-------------------------------------------------------------------------------

	#
	# Prints a label belonging to the $Address.
	#

sub print_label($)
  {
  my $Address = $_[0];
  my $label;

  if (defined($labels_by_address{$Address}))
    {
    $label = \%{$labels_by_address{$Address}};
    print "\n;$border0\n" if ($label->{TYPE} == SUB);

    printf "\n$label->{NAME}:\n\n";
    $label->{PRINTED} = TRUE;
    $prev_is_jump = FALSE;
    return TRUE;
    }

  return FALSE;
  }

################################################################################
################################################################################

	#
	# Auxiliary procedure. Adds a register to the sfrs list.
	#

sub reg_add_to_list($$)
  {
  my ($Address, $Name) = @_;

  if (! defined($sfrs_by_address{$Address}))
    {
    $sfrs_by_address{$Address} = $Name;
    }
  else
    {
    Log(sprintf("Warning, the address: 0x%03X already busy by the $sfrs_by_address{$Address} register.", $Address), 2);
    }

  $sfrs_by_names{$Name} = $Address;
  }

#-------------------------------------------------------------------------------

	#
	# Auxiliary procedure. Adds a bit to the bits list.
	#

sub bit_add_to_list($$)
  {
  my ($Address, $Name) = @_;

  if (! defined($bits_by_address{$Address}))
    {
    $bits_by_address{$Address} = $Name;
    }
  else
    {
    Log(sprintf("Warning, the address: 0x%03X already busy by the $bits_by_address{$Address} bit.", $Address), 2);
    }
  }

#-------------------------------------------------------------------------------

	#
	# Reads the sfrs and bits from the $Line.
	#

sub process_header_line($)
  {
  my $Line = $_[0];

  Log((' ' x $embed_level) . $Line, 5);

  if ($Line =~ /^#\s*include\s+["<]\s*(\S+)\s*[">]$/o)
    {
    $embed_level += 4;
    &read_header("$include_path/$1");
    $embed_level -= 4;
    }
  elsif ($Line =~ /^__sfr\s+__at\s*(?:\(\s*)?0x([[:xdigit:]]+)(?:\s*\))?\s+([\w_]+)/io)
    {
	# __sfr __at (0x80) P0 ;  /* PORT 0 */

    reg_add_to_list(hex($1), $2);
    }
  elsif ($Line =~ /^SFR\s*\(\s*([\w_]+)\s*,\s*0x([[:xdigit:]]+)\s*\)/io)
    {
	# SFR(P0, 0x80); // Port 0

    reg_add_to_list(hex($2), $1);
    }
  elsif ($Line =~ /^sfr\s+([\w_]+)\s*=\s*0x([[:xdigit:]]+)/io)
    {
	# sfr P1  = 0x90;

    reg_add_to_list(hex($2), $1);
    }
  elsif ($Line =~ /^__sbit\s+__at\s*(?:\(\s*)?0x([[:xdigit:]]+)(?:\s*\))?\s+([\w_]+)/io)
    {
	# __sbit __at (0x86) P0_6  ;

    bit_add_to_list(hex($1), $2);
    }
  elsif ($Line =~ /^SBIT\s*\(\s*([\w_]+)\s*,\s*0x([[:xdigit:]]+)\s*,\s*(\d)\s*\)/io)
    {
	# SBIT(P0_0, 0x80, 0); // Port 0 bit 0

    bit_add_to_list(hex($2) + int($3), $1);
    }
  elsif ($Line =~ /^sbit\s+([\w_]+)\s*=\s*0x([[:xdigit:]]+)/io)
    {
	# sbit P3_1 = 0xB1;

    bit_add_to_list(hex($2), $1);
    }
  elsif ($Line =~ /^sbit\s+([\w_]+)\s*=\s*([\w_]+)\s*\^\s*(\d)/io)
    {
	# sbit SM0  = SCON^7;

    my ($name, $reg, $bit) = ($1, $2, $3);

    bit_add_to_list($sfrs_by_names{$reg} + $bit, $name) if (defined($sfrs_by_names{$reg}));
    }
  }

#-------------------------------------------------------------------------------

	#
	# Reads in a MCU.h file.
	#

sub read_header($)
  {
  my $Header = $_[0];
  my ($fh, $pre_comment, $comment, $line_number);
  my $head;

  if (! open($fh, '<', $Header))
    {
    print STDERR "$PROGRAM: Could not open. -> \"$Header\"\n";
    exit(1);
    }

  $head = ' ' x $embed_level;

  Log("${head}read_header($Header) >>>>", 5);

  $comment = FALSE;
  $line_number = 1;
  while (<$fh>)
    {
    chomp;
    s/\r$//o;		# '\r'

	# Filters off the C comments.

    s/\/\*.*\*\///o;	# /* ... */
    s/\/\/.*$//o;	# // ...
    s/^\s*|\s*$//go;

    if ($_ =~ /\/\*/o)		# /*
      {
      $pre_comment = TRUE;
      s/\s*\/\*.*$//o;
      }
    elsif ($_ =~ /\*\//o)	# */
      {
      $pre_comment = FALSE;
      $comment = FALSE;
      s/^.*\*\/\s*//o;
      }

    if ($comment)
      {
      ++$line_number;
      next;
      }

    $comment = $pre_comment if ($pre_comment);

    if ($_ =~ /^\s*$/o)
      {
      ++$line_number;
      next;
      }

    run_preprocessor($Header, \&process_header_line, $_, $line_number);
    ++$line_number;
    } # while (<$fh>)

  Log("${head}<<<< read_header($Header)", 5);
  close($fh);
  }

#-------------------------------------------------------------------------------

	#
	# Among the blocks stows description of an instruction.
	#

sub add_instr_block($$)
  {
  my ($Address, $Instruction) = @_;
  my $instr_size = $instruction_sizes[$Instruction];

  if (! $instr_size)
    {
    $instr_size = 1;
    add_block($Address, BLOCK_CONST, $instr_size, BL_LABEL_NONE);
    }
  else
    {
    add_block($Address, BLOCK_INSTR, $instr_size, BL_LABEL_NONE);
    }

  return $instr_size;
  }

#-------------------------------------------------------------------------------

	#
	# Splits the program into small blocks.
	#

sub split_code_to_blocks()
  {
  my ($i, $instr, $size);
  my ($is_empty, $empty_begin);
  my ($is_const, $const_begin);

  $is_empty = FALSE;
  $is_const = FALSE;
  for ($i = 0; $i < $rom_size; )
    {
    $instr = $rom[$i];

    if ($instr != EMPTY)
      {
      if ($is_empty)
	{
	# The end of the empty section.

	$is_empty = FALSE;
	add_block($empty_begin, BLOCK_EMPTY, $i - $empty_begin, BL_LABEL_NONE);
	}

      if (is_constant($i))
	{
	if (! $is_const)
	  {
	  $const_begin = $i;
	  $is_const = TRUE;
	  }

	++$i;
	}
      else
	{
	if ($is_const)
	  {
	# The end of the constant section.

	  add_block($const_begin, BLOCK_CONST, $i - $const_begin, BL_LABEL_NONE);
	  $is_const = FALSE;
	  }

	$i += add_instr_block($i, $instr);
	}
      } # if ($instr != EMPTY)
    else
      {
      if (! $is_empty)
	{
	# The begin of the empty section.

	if ($is_const)
	  {
	# The end of the constant section.

	  add_block($const_begin, BLOCK_CONST, $i - $const_begin, BL_LABEL_NONE);
	  $is_const = FALSE;
	  }

	$empty_begin = $i;
	$is_empty = TRUE;
	}

      ++$i;
      }
    } # for ($i = 0; $i < $rom_size; )

  if ($is_const)
    {
    add_block($const_begin, BLOCK_CONST, $i - $const_begin, BL_LABEL_NONE);
    }
  elsif ($is_empty)
    {
    add_block($empty_begin, BLOCK_EMPTY, $i - $empty_begin, BL_LABEL_NONE);
    }
  }

#-------------------------------------------------------------------------------

	#
	# Finds address of branchs and procedures.
	#

sub find_labels_in_code()
  {
  foreach (sort {$a <=> $b} keys(%blocks_by_address))
    {
    my $ref = \%{$blocks_by_address{$_}};

    label_finder($ref) if ($ref->{TYPE} == BLOCK_INSTR);
    }
  }

#-------------------------------------------------------------------------------

	#
	# Prints a table of constants.
	#

sub print_constants($)
  {
  my $BlockRef = $_[0];
  my ($size, $addr, $i, $len, $frag, $byte, $spc, $col);
  my @constants;

  $size = $BlockRef->{SIZE};

  return if (! $size);

  $prev_is_jump = FALSE;

  $col  = ($gen_assembly_code) ? '      ' : '    ';
  $addr = $BlockRef->{ADDR};
  @constants = @rom[$addr .. ($addr + $size - 1)];
  $i = 0;
  while (TRUE)
    {
    $len = $size - $i;

    last if (! $len);

    $len = TBL_COLUMNS if ($len > TBL_COLUMNS);

    if ($gen_assembly_code)
      {
      print "\t.db\t";
      }
    else
      {
      printf "0x%04X:\t\t.db\t", $addr;
      }

    if (($spc = $addr % TBL_COLUMNS))
      {
      print ($col x $spc);
      $frag = TBL_COLUMNS - $spc;
      $len  = $frag if ($len > $frag);
      }

    $addr += $len;
    while (TRUE)
      {
      $byte = $constants[$i++];
      $spc  = (--$len) ? ' ' : '';

      if ($gen_assembly_code)
	{
	printf((($hex_constant || $byte < ord(' ') || $byte >= 0x7F) ? "0x%02X" : "'%c'$spc"), $byte);

	last if (! $len);
	print ', ';
	}
      else
	{
	printf((($hex_constant || $byte < ord(' ') || $byte >= 0x7F) ? "%02X$spc" : "'%c'"), $byte);

	last if (! $len);
	print ' ';
	}
      }

    print "\n";
    } # while (TRUE)
  $prev_is_jump = FALSE;
  }

#-------------------------------------------------------------------------------

	#
	# Disassembly contents of $blocks_by_address array.
	#

sub disassembler()
  {
  my $ref;

  $prev_is_jump = FALSE;
  invalidate_DPTR_Rx();
  print "\n";

  foreach (sort {$a <=> $b} keys(%blocks_by_address))
    {
    $ref = \%{$blocks_by_address{$_}};

    if ($ref->{TYPE} == BLOCK_INSTR)
      {
      invalidate_DPTR_Rx() if (print_label($_));
      print "\n" if ($prev_is_jump);

      instruction_decoder($ref);
      }
    elsif ($ref->{TYPE} == BLOCK_CONST)
      {
      print_label($_);
      print "\n" if ($prev_is_jump);

      print_constants($ref);
      }
    elsif ($ref->{TYPE} == BLOCK_EMPTY)
      {
      my $next_block = $_ + $ref->{SIZE};

      if (! $gen_assembly_code)
	{
	printf("\n0x%04X: -- -- --\n  ....  -- -- --\n0x%04X: -- -- --\n",
		$_, $next_block - 1);
	}
      elsif ($next_block < $rom_size)
	{
	# Skip the empty code space.

	printf "\n\t.ds\t%u\n", $ref->{SIZE};
	}
      }
    }
  }

#-------------------------------------------------------------------------------

	#
	# If there are datas in the code, it is possible that some labels will
	# be lost. This procedure prints them.
	#

sub print_hidden_labels()
  {
  foreach (sort {$a <=> $b} keys(%labels_by_address))
    {
    if (! $labels_by_address{$_}->{PRINTED})
      {
      print STDERR "The label: $labels_by_address{$_}->{NAME} is hidden!\n";
      }
    }
  }

################################################################################
################################################################################

sub usage()
  {
  print <<EOT;
Usage: $PROGRAM [options] <hex file>

    Options are:

	-r|--rom-size <size of program memory>

EOT
;
  printf "\t    Defines size of the program memory. (Default %u bytes.)\n", MCS51_ROM_SIZE;
  print <<EOT;

	--const-area <start address> <end address>

	    Designates a constant area, where data is stored happen. The option
	    may be given more times, that to select more areas at the same time.

	-hc|--hex-constant

	    The constants only shows in hexadecimal form. Otherwise if possible,
	    then shows all in character form.

	-I|--include <path to headers>

	    Path of the header files. (Default: $default_include_path)

	-M|--mcu <header.h>

	    Header file of the MCU.

	--map-file <file.map>

	    The map file belonging to the input hex file. (optional)

	-as|--assembly-source

	    Generates the assembly source file. (Eliminates before the instructions
	    visible address, hex codes and besides replaces the pseudo Rn<#x>
	    register names.)

	-ne|--no-explanations

	    Eliminates after the instructions visible explaining texts.

	-v <level> or --verbose <level>

	    It provides information on from the own operation.
	    Possible value of the level between 0 and 10. (default: 0)

	-h|--help

            This text.
EOT
;
  }

################################################################################
################################################################################
################################################################################

foreach (@default_paths)
  {
  if (-d $_)
    {
    $default_include_path = $_;
    last;
    }
  }

if (! @ARGV)
  {
  usage();
  exit(1);
  }

for (my $i = 0; $i < @ARGV; )
  {
  my $opt = $ARGV[$i++];

  given ($opt)
    {
    when (/^-(r|-rom-size)$/o)
      {
      param_exist($opt, $i);
      $rom_size = str2int($ARGV[$i++]);

      if ($rom_size < 1024)
	{
	printf STDERR "$PROGRAM: Code size of the MCS51 family greater than 1024 bytes!\n";
	exit(1);
	}
      elsif ($rom_size > MCS51_ROM_SIZE)
	{
	printf STDERR "$PROGRAM: Code size of the MCS51 family not greater %u bytes!\n", MCS51_ROM_SIZE;
	exit(1);
	}
      }

    when (/^--const-area$/o)
      {
      my ($start, $end);

      param_exist($opt, $i);
      $start = str2int($ARGV[$i++]);

      param_exist($opt, $i);
      $end = str2int($ARGV[$i++]);

      if ($start > $end)
	{
	my $t = $start;

	$start = $end;
	$end = $t;
	}
      elsif ($start == $end)
	{
	$start = MCS51_ROM_SIZE - 1;
	$end   = MCS51_ROM_SIZE - 1;
	}

      $const_areas_by_address{$start} = $end if ($start < $end);
      } # when (/^--const-area$/o)

    when (/^-(hc|-hex-constant)$/o)
      {
      $hex_constant = TRUE;
      }

    when (/^-(I|-include)$/o)
      {
      param_exist($opt, $i);
      $include_path = $ARGV[$i++];
      }

    when (/^-(M|-mcu)$/o)
      {
      param_exist($opt, $i);
      $header_file = $ARGV[$i++];
      }

    when (/^--map-file$/o)
      {
      param_exist($opt, $i);
      $map_file = $ARGV[$i++];
      }

    when (/^-(as|-assembly-source)$/o)
      {
      $gen_assembly_code = TRUE;
      }

    when (/^-(ne|-no-explanations)$/o)
      {
      $no_explanations = TRUE;
      }

    when (/^-(v|-verbose)$/o)
      {
      param_exist($opt, $i);
      $verbose = int($ARGV[$i++]);
      $verbose = 0 if (! defined($verbose) || $verbose < 0);
      $verbose = 10 if ($verbose > 10);
      }

    when (/^-(h|-help)$/o)
      {
      usage();
      exit(0);
      }

    default
      {
      if ($hex_file eq '')
	{
	$hex_file = $opt;
	}
      else
	{
	print STDERR "$PROGRAM: We already have the source file name.\n";
	exit(1);
	}
      }
    } # given ($opt)
  } # for (my $i = 0; $i < @ARGV; )

$include_path = $default_include_path if ($include_path eq '');

if ($hex_file eq '')
  {
  print STDERR "$PROGRAM: What do you have to disassembled?\n";
  exit(1);
  }

is_file_ok($hex_file);

if ($map_file eq '')
  {
  ($map_file) = ($hex_file =~ /^(.+)\.hex$/io);
  $map_file .= '.map';
  }

$map_file = '' if (! -e $map_file);

init_mem(0, $rom_size - 1);
read_hex($hex_file);

if ($header_file ne '')
  {
  is_file_ok("$include_path/$header_file");
  reset_preprocessor();
  $embed_level = 0;
  read_header("$include_path/$header_file");
  }

read_map_file();
fix_multi_byte_variables();
split_code_to_blocks();
find_labels_in_code();
add_names_labels();
disassembler();
print_hidden_labels() if ($verbose > 2);
