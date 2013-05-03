***README***

SysTimeTool
Created by Jay Ovalle, Colton Spahmer, and Andrew Smith.
Rochester Institute of Technology, Spring 2013-14

------- SysTimeTool -------
SysTimeTool is a script written in Perl that allows you analyze timestamp discrepancies in log files using a user-defined time gap. SysTimeTool is 100% open source and is capable of working with virtually any log assuming the log follows a similar time->event format as in most UNIX-based log files.

Compatability:
	* Unix/Linux based operating systems (preferably BackTrack or Kali)
	* Perl 5.6 or Later

------- Download/Installation -------
wget SysToolTime.pl
cp SysToolTime.pl /usr/bin/SysToolTime.pl

------- Usage -------
SysToolTime.pl -t hh:mm:ss
SysToolTime.pl -a

This tool can also be used to output the number and times of authentication failures so that the user can look for abnormalities

*Important Note* Log file entries from December to January (Or any changes over a year's time) will be detected as a reverse time error. This is a false positive that we could fix; however, it could then be exploited by an attacker.
