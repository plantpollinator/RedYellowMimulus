# RedYellowMimulus
Custom code used in Wenzell, Neequaye et al. on red-yellow transitions in Mimulus wildflowers. Manuscript available here: https://www.biorxiv.org/content/10.1101/2023.10.29.564637v3.full

The repository contains three Perl script files, all licensed under the MIT License:

eagstimKatieRedYellow.pl randomizes stimuli to present to insect antennae using an EAG setup

unknowns2tsv-layout.pl takes a modified Agilent Unknowns software PDF output (modified to have very tiny text to avoid linewraps in compound names and to export 3 ID hits per peak) and converts the three hits into a single line per peak with columns representing the three hits

gcms-blank-parser.pl takes the file output from unknowns2tsv-layout.pl for an experimental sample and a blank (negative control) sample and identifies matching peaks from the blank in the experimental sample within a given time window, calculates the ratio between areas for the blank and experimental peak, and writes a TSV file out with these data suitable for processing in e.g. Microsoft Excel or another spreadsheet program.
