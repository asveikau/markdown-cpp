# The purpose of this file is to add the NOMARKDOWN/END_NOMARKDOWN
# escapes.  This is clumsy to do in a shell script and we already
# take dependency on perl for markdown.pl, so why not...

use strict;

my $markdown = 1;

open(MD, "| perl markdown.pl") || die "failed to mark down\n";

while (<>)
{
   chomp;
   my $line = $_;

   if ($markdown && ($line eq "NOMARKDOWN"))
   {
      $markdown = 0;
      close(MD);
      wait;
   }
   elsif ((!$markdown) && ($line eq "END_NOMARKDOWN"))
   {
      $markdown = 1;
      open(MD, "| perl markdown.pl") || die "failed to mark down\n";
   }
   elsif ($markdown)
   {
      print MD "$line\n";
   }
   else
   {
      print "$line\n";
   }
}

if ($markdown)
{
   close(MD);
   wait;
}
