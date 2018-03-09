@rem = '--*-Perl-*--
@echo off
cls

rem @echo The OS of this machine is "%OS%". The SystemRoot is "%SystemRoot%"

if "%OS%" == "Windows_NT" goto WinNT
perl -x -S "%0" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto endofperl
:WinNT
perl -x -S %0 %*
if NOT "%COMSPEC%" == "%SystemRoot%\system32\cmd.exe" goto endofperl
if %errorlevel% == 9009 echo You do not have Perl in your PATH.
if errorlevel 1 goto script_failed_so_exit_with_non_zero_val 2>nul
goto endofperl
@rem ';




#!perl 

#print "$^O is the OS-name of the PERL-binary \n";

#============================================================

#$pfad0 = 'fragenkatalog.txt';
$pfad0 = 'spezial.txt';
#$pfad01 = 'ffw_k01.htm';


#============================================================
#$vorheriger_kapitel_name = "ABC-Gefahrstoffe";
$vorheriger_kapitel_name = "QWERTZ";
#$kapitel_name = "ABC-Gefahrstoffe";
$kapitel_name = "Test";
$out_datei = "DATEI_OUT";
$datei_nummer = 25; 
#$datei_nummer = 0; 
$neue_zeilen_nummer = 0;

$num_fragen_dieses_kapitel = 0;
$Zeilen_nummer             = 0;
$Kapitel_gefunden          = 0;
$num_fragen_dieses_kapitel = 0;
$Fragen_nummerierung       = 0;
$Frage_Zeilennummer        = 4;
$Frage_aktiv               = 0;
@Frage                    = ();
 
# erste Datei einlesen
open (DATEI    , "<$pfad0") or die "Konnte Datei $pfad1 nicht oeffnen!";

sub SCHREIBE_DATEI_KOPF()
{
  $datei_num_string = sprintf "%2d",$datei_nummer;
  $datei_pfad = sprintf "ffw_k%2d.htm",$datei_nummer; 
#  $datei_pfad = sprintf "ffw_s%2d.htm",$datei_nummer; 
  $_ = $datei_pfad;
  s/\s/0/;
  $datei_pfad = $_;
  $datei_out = $out_datei.$datei_num_string;
  open ($datei_out, ">$datei_pfad");
  printf ($datei_out "<HTML>\n<HEAD>\n<SCRIPT type=\"text/javascript\">\nif (parent.frames.length<4) window.top.location.href=\"fragebogen.htm\";\n\nparent.Index.Thema = \'%s\';\nparent.Index.LetzteFrage = %d;\nvar t = new parent.Index.makeFragen(parent.Index.LetzteFrage);\n\nfunction FuelleFragen() {\n",$vorheriger_kapitel_name,$num_fragen_dieses_kapitel-1);
}
sub SCHREIBE_KAPITEL_DATEN()
{
  if ($num_fragen_dieses_kapitel > 0)
  {
    for ($nummer = 1; $nummer < $num_fragen_dieses_kapitel; $nummer++)
    {
      if (!($Frage[$nummer][0] eq ""))
      {
        printf ($datei_out "t[%d].ok = \"%s\";\n",$nummer,$Frage[$nummer][4]);
      }
    }
    printf ($datei_out "}\n\nfunction FuelleAntwort() {\n");
    for ($nummer = 1; $nummer < $num_fragen_dieses_kapitel; $nummer++)
    {
      if (!($Frage[$nummer][0] eq ""))
      {
        printf ($datei_out "t[%d].frage = \"%s\";\n",$nummer,$Frage[$nummer][0]);
        printf ($datei_out "t[%d].a = \"%s\";\n"    ,$nummer,$Frage[$nummer][1]);
        printf ($datei_out "t[%d].b = \"%s\";\n"    ,$nummer,$Frage[$nummer][2]);
        printf ($datei_out "t[%d].c = \"%s\";\n"    ,$nummer,$Frage[$nummer][3]);
#        printf ($datei_out "%s\n%s\n%s\n%s\n",$Frage[$nummer][0],$Frage[$nummer][1],$Frage[$nummer][2],$Frage[$nummer][3]);
      }
    }
    printf ($datei_out "}\n\n</SCRIPT>\n\n</HEAD>\n<BODY onLoad = 'parent.Index.AllesBereit();'>\n&nbsp;\n</BODY>\n</HTML>\n");


  }
}


while(<DATEI>)
{
  chomp($_);
  if ($_ =~ m/^[0-9]*\.\s*/)
  {
     $neue_zeilen_nummer++;
#     if (0)
     if ($neue_zeilen_nummer == 59)
     {
         push(@datei, "Fragenkatalog $Spezial_kapitel 12.13 Antwortbogen  -  Seite 1 von 2"); 
         $neue_zeilen_nummer = 1;
         $Spezial_kapitel++;
     }
  }
  s/ä/&auml;/g;
  s/ö/&ouml;/g;
  s/ü/&uuml;/g;
  s/Ä/&Auml;/g;
  s/Ö/&Ouml;/g;
  s/Ü/&Uuml;/g;
  s/ß/&szlig;/g;
  s/"/“/g;
  s/^[0-9]*\.\s*/$neue_zeilen_nummer\.  /;
  print $_;
  print "\n";

  push(@datei, $_);
}
close(DATEI);
foreach my $zeile (@datei)
{
  $Zeilen_nummer++;
  if (  (($zeile =~ m/^Antwortenkatalog/) && ($zeile =~ m/Seite/))
      ||(($zeile =~ m/^Fragenkatalog/)    && ($zeile =~ m/Seite/))
     )
  {
    $_ = $zeile;
    $Frage_aktiv = 0; 
    s/Antwortenkatalog\s*//;
    s/Fragenkatalog\s*//;
    s/\s*[0-9]+\.*\s*[0-9]+\s*Antwortbogen\s*-\s*Seite\s*[0-9]+\s*von\s*[0-9]+\s*//;
    if (!($kapitel_name eq $_))
    {
      $kapitel_name = $_;
#      print $kapitel_name;
#      print $datei_nummer;
#      print "\n";
    }
    if (!($vorheriger_kapitel_name eq $kapitel_name))
    {
      $num_fragen_dieses_kapitel = $Fragen_nummerierung;
      print "_yy_";
      print $num_fragen_dieses_kapitel;
      print "\n";
      SCHREIBE_DATEI_KOPF();
      SCHREIBE_KAPITEL_DATEN();
      $vorheriger_kapitel_name = $kapitel_name ;
      $datei_nummer++;
      $Fragen_nummerierung       = 1;
      @Frage                     = ();
      $Kapitel_gefunden = 0;
    }
    if ($Kapitel_gefunden == 0)
    {
#      print "_xx_";
#      print $num_fragen_dieses_kapitel;
#      print "\n";
      $Kapitel_gefunden          = 1;
    }
  } 
  if ($Kapitel_gefunden == 1)
  {
    if ($zeile =~ m/^$Fragen_nummerierung\./)
#    if ($zeile =~ m/^[0-9]*\.\s*/)
    {
      $_ = $zeile;
      s/^[0-9]*\.\s*//;
      $zeile = $_;
      $Frage[$Fragen_nummerierung][0] = $zeile;
#      print $Fragen_nummerierung;
#      print "__";
#      print $Frage_Zeilennummer;
#      print "\n";
      if ($Frage_Zeilennummer == 4)
      {
        $Fragen_nummerierung++;
      }
      else
      {
        print "FEHLER_Nummerierung:";
        print $Zeilen_nummer;
        print " , ";
        print $Fragen_nummerierung;
        print "\nyyyy $zeile yyyy\n";
        $Kapitel_gefunden = 0;
      }
      $Frage_Zeilennummer = 1;
      $Frage_aktiv = 1;
    }
    else
    {
#      print $Fragen_nummerierung;
#      print "_x_";
#      print $Frage_Zeilennummer;
#      print "__";
#      print $zeile;
#      print "\n";
#      print $Zeilen_nummer;
#      print "_aa_";
#      print $Frage_aktiv;
#      print "\n";
      if ($Frage_aktiv == 1)
      {
#        print $Fragen_nummerierung;
#        print "_o_";
#        print $Frage_Zeilennummer;
#        print "\n";
        if ($Frage_Zeilennummer < 4)
        {
          $_ = $zeile;
          if (  ($_ =~ m/^x\s*/)
              ||($_ =~ m/^X\s*/)
             )
          {
            if ($Frage_Zeilennummer == 1)
            {
              $Frage[$Fragen_nummerierung-1][4] = "a";
            }
            else
            {
              if ($Frage_Zeilennummer == 2)
              {
                $Frage[$Fragen_nummerierung-1][4] = "b";
              }
              else
              {
                if ($Frage_Zeilennummer == 3)
                {
                  $Frage[$Fragen_nummerierung-1][4] = "c";
                }
              }
            }
          }
          s/^x\s*//;
          s/^X\s*//;
          $zeile = $_;
          $Frage[$Fragen_nummerierung-1][$Frage_Zeilennummer] = $zeile;
        }
        else
        {
          if ($zeile =~ m/^$Fragen_nummerierung\./)
          {
            $Frage_Zeilennummer = 1;
            print "FEHLER_Zeilennummer:";
            print $Zeilen_nummer;
            print "\n";
            $Frage_aktiv = 0;
            $Kapitel_gefunden = 0;
          }
        }
        $Frage_Zeilennummer++;
      }
      $num_fragen_dieses_kapitel = $Fragen_nummerierung;
    }
  }
}
$num_fragen_dieses_kapitel = $Fragen_nummerierung;
SCHREIBE_DATEI_KOPF();
SCHREIBE_KAPITEL_DATEN();
close($datei_out);
     
__END__
:endofperl
