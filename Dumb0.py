###################### dumb0 #######################
# Coded by The X-C3LL (J.M. Fernandez)             #
# Blog: 0verl0ad.blogspot.com                      #
# Twitter: https://twitter.com/TheXC3LL            #
######################  v0.1.3  ####################


#Dumb0: Simple Script to harvest usernames in populars forums and CMS


#    Copyright (C) 2018  Juan Manuel Fernandez

#   This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.

#  You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


# Modules
import argparse
import re
import requests
import signal

def signal_handler(signal, frame):
    print "\n[!] Exiting..."
    exit(0)
signal.signal(signal.SIGINT, signal_handler)

def cms_list():
    print """
    Supported:
            SMF      --     Simple Machine Forums
            IPB      --     Invision Power Board
            XEN      --     Xen Foro
            VB       --     vBulletin
            myBB     --
            useBB    --
            vanilla  --
            bbPress  --
            WP   --     WordPress
            SPIP     --     SPIP CMS
            MOODLE   --     Moodle
            BEE  --     Beehive Forums
            FLUX     --     fluxBB
            FUD  --     FUDforum
            punBB    --
            ACM  --     AcmImBoard XD
            BURN     --     Burning Board
            COM  --     Community Servers
            deluxeBB --
            fusionBB --
            JFORUM   --
            JITBIT   --     Jibit ASPNetForum
            JIVE     --     Jive Forums
            NEAR     --     Near Forums
            OVBB     --
            TikiWiki --     TikiWiki CMS-Groupware
"""

helper = {
    "SMF" : ['/index.php?action=profile;u='],
    "IPB" : ['/index.php?showuser='],
    "XEN" : ['/members/'],
    "VB" : ["/member.php?u="],
    "myBB" : ["/member.php?action=profile&uid="],
    "useBB" : ["/profile.php?id="],
    "vanilla" : ["/account/"],
    "bbPress" : ["/profile.php?id="],
    "WP" : ["/?author="],
    "SPIP" : ["/spip.php?auteur"],
    "MOODLE" : ["/user/view.php?id="],
    "BEE" : ["/user_profile.php?uid="],
    "FLUX" : ["/profile.php?id="],
    "FUD" : ["/index.php?t=usrinfo&id="],
    "punBB" : ["/profile.php?id="],
    "ACM" : ["/?page=profile&id="],
    "BURN" : ["/profile.php?userid="],
    "COM" : ["/user/Profile.aspx?UserID="],
    "deluxeBB" : ["/misc.php?sub=profile&uid="],
    "fusionBB" : ["/showuser.php?uid/"],
    "JFORUM" : ["/jforum/user/profile/", ".page"],
    "JITBIT" : ["/viewprofile.aspx?UserID="],
    "JIVE" : ["/profile/"],
    "NEAR" : ["/users/"],
    "OVBB" : ["/member.php?action=getprofile&userid="],
    "TikiWiki" : ["/tiki-user_information.php?userId="]
}

def get_user(url, cookies, userid, cms):
    headers = {'user-agent' : 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36', 'cookies': cookies}

    if len(helper[cms]) == 2:
        url_completed = url + helper[cms][0] + str(userid) + helper[cms][1]
    else:
        url_completed = url + helper[cms][0] + str(userid)

    req = requests.get(url_completed, headers=headers)
    if req.status_code == requests.codes.ok:
        match = re.search('\<title\>(.*?)\<\/title\>',req.text)
        return match.group(0)[7:-8]
    else:
        print "[-] Error: URL not returned 200 STATUS OK"
        return -1

def banner():
    print """
                  @TheXC3LL
 ______            _______  ______   _______
(  __  \ |\     /|(       )(  ___ \ (  __   )
| (  \  )| )   ( || () () || (   ) )| (  )  |
| |   ) || |   | || || || || (__/ / | | /   |
| |   | || |   | || |(_)| ||  __ (  | (/ /) |
| |   ) || |   | || |   | || (  \ \ |   / | |
| (__/  )| (___) || )   ( || )___) )|  (__) |
(______/ (_______)|/     \||/ \___/ (_______)
                                             v0.1.3

"""


banner()

# Parameters
parser = argparse.ArgumentParser(description="Harvest usernames from forums / CMS.")

parser.add_argument('--type', help='Forum / CMS code. To see all types available use --list', dest='tipo')
parser.add_argument('--list', help='Show all focum / CMS codes available', action='store_true', dest='listar')
parser.add_argument('--url', help='Target URL', dest='url')
parser.add_argument('--cookie', help='If needed, session cookie', dest='cookie')

args = parser.parse_args()

# Check parameters
if args.listar:
    cms_list()
    exit(0)

if not args.url and not args.tipo:
    print "[!] Syntax error. Check help with -h"
    exit(0)

if args.tipo not in helper:
    print "[!] Error: type code not found. Check the list with --list"
    exit(0)

cookie = ''
if args.cookie:
    cookie = args.cookie

# Check if URL is up
print "[+] Testing url..."
test = get_user(args.url, cookie, 2, args.tipo)
print "[+] Check it: " + test
before = raw_input("[?] If BEFORE the nick appears any text, type it (to clean the output): ")
after = raw_input("[?] If AFTER the nick appears any text, type it (to clean the outpu)t: ")

print "[+] Example of nick: " + test[len(before):len(test) - len(after)]
raw_input("Press any key to start the dump... ")

print "[+] Dumping!\n========================\n"

# Max failed attemps before quit
fails = 0
current_user = 1

while (fails <= 20):
    user = get_user(args.url, cookie, current_user, args.tipo)
    if user == -1:
        fails = fails + 1
    else:
        fails = 0
        print user[len(before):len(user) - len(after)]
    current_user = current_user + 1

print "========================"
print "[+] Finished"
