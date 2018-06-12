#!/usr/bin/env perl
$latex            = 'uplatex -synctex=1 ';
$latex_silent     = 'uplatex -synctex=1 -interaction=batchmode';
$bibtex           = 'upbibtex';
$dvipdf           = 'dvipdfmx %O -o %D %S';
$makeindex        = 'mendex %O -o %D %S';
$max_repeat       = 5;
$pdf_mode	  = 3; # generates pdf via dvipdfmx
$pdf_previewer = "open";
