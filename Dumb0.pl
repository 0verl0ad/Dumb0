###################### dumb0 #######################
# Coded by The X-C3LL (J.M. Fernández)             #
# Email: overloadblog////hotmail////es             #
# Blog: 0verl0ad.blogspot.com                      #
# Twitter: https://twitter.com/TheXC3LL            #
######################  v0.1  ######################

use LWP::UserAgent;
use Getopt::Long;

GetOptions(
		"type=s"=> \$flag_type,
		"url=s"=> \$flag_url,
		"log"=>  \$flag_log
         );

print q(
    ;'*¨'`·- .,  ‘               .-,             ,'´¨';'        ,·'´¨;.  '                         ,.  - · - .,  '              , ·. ,.-·~·.,   ‘    
    \`:·-,. ,   '` ·.  '         ;  ';\          ,'   ';'\'      ;   ';:\           .·´¨';\   ,·'´,.-,   ,. -.,   `';,'          /  ·'´,.-·-.,   `,'‚    
     '\:/   ;\:'`:·,  '`·, '     ';   ;:'\        ,'   ,'::'\    ;     ';:'\      .'´     ;:'\   \::\.'´  ;'\::::;:'  ,·':\'       /  .'´\:::::::'\   '\ °  
      ;   ;'::\;::::';   ;\     ';  ';::';      ,'   ,'::::;    ;   ,  '·:;  .·´,.´';  ,'::;'    '\:';   ;:;:·'´,.·'´\::::';   ,·'  ,'::::\:;:-·-:';  ';\‚  
      ;  ,':::;  `·:;;  ,':'\'   ';  ';::;     ,'   ,'::::;'    ;   ;'`.    ¨,.·´::;'  ;:::;     ,.·'   ,.·:'´:::::::'\;·´   ;.   ';:::;´       ,'  ,':'\‚ 
     ;   ;:::;    ,·' ,·':::;   ';  ';::;    ,'   ,'::::;'     ;  ';::; \*´\:::::;  ,':::;‘     '·,   ,.`' ·- :;:;·'´        ';   ;::;       ,'´ .'´\::';‚
     ;  ;:::;'  ,.'´,·´:::::;    \   '·:_,'´.;   ;::::;‘    ';  ,'::;   \::\;:·';  ;:::; '        ;  ';:\:`*·,  '`·,  °    ';   ':;:   ,.·´,.·´::::\;'°
    ':,·:;::-·´,.·´\:::::;´'      \·,   ,.·´:';  ';:::';     ;  ';::;     '*´  ;',·':::;‘          ;  ;:;:'-·'´  ,.·':\       \·,   `*´,.·'´::::::;·´   
     \::;. -·´:::::;\;·´          \:\¯\:::::\`*´\::;  '   \´¨\::;          \¨\::::;        ,·',  ,. -~:*'´\:::::'\‘      \\:¯::\:::::::;:·´      
      \;'\::::::::;·´'               `'\::\;:·´'\:::'\'   '    '\::\;            \:\;·'          \:\`'´\:::::::::'\;:·'´        `\:::::\;::·'´  °       
         `\;::-·´                               `*´°         '´¨               ¨'             '\;\:::\;: -~*´‘                ¯                  
                                                 '                                                     '                        ‘   
								http://0verl0ad.blogspot.com               

);


if (!$flag_type or !$flag_url) {
	&use;
	exit;
}

if ($flag_type eq "SMF") { $tail = "/index.php?action=profile;u="; }
if ($flag_type eq "IPB") { $tail = "/index.php?showuser="; }
if ($flag_type eq "XEN") { $tail = "/members/"; }
if ($flag_type eq "VB") { $tail = "/member.php?u="; }
if ($flag_type eq "myBB") { $tail = "/user-"; $add = ".html";}
if ($flag_type eq "useBB") { $tail = "/profile.php?id="; }
if ($flag_type eq "vanilla") { $tail = "/account/"; }
if ($flag_type eq "bbPress") { $tail = "/profile.php?id="; }
if ($flag_type eq "WP") { $tail = "/?author="; }
if ($flag_type eq "SPIP") { $tail = "/spip.php?auteur"; }

if ($flag_log) {
	print "[!] Introduzca la cookie para mandar las peticiones desde su sesion\n\n";
	print "/!\\ Cookie> ";
	$cookie = <STDIN>;
	chomp($cookie);
}
$i = "1";


print "[!] Para poder iniciar la busqueda de usuarios primero usted debe indicar el patron a eliminar\n";
print "[!] Copie y pege debajo el texto que viene DESPUES del author incluyendo el espacio\n\n";

$ua = LWP::UserAgent->new; $ua->agent('Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131030');
$response = $ua->get($flag_url.$tail."2", Cookie => $cookie);
$html = $response->decoded_content;
@contenido = split("\n", $html);
foreach $linea (@contenido) {
	if ($linea =~ m/\<title\>(.*?)\<\/title\>/g) {
		print "/!\\-> ".$1."\n\nInserte aqui > ";
		$patron = <STDIN>;
		chomp($patron);
		$size = length($patron);
		$off = 0 - $size;
	}
}
 

print "\n[!] Empezando el dumpeo en $flag_url...\n\n";

while ($i != -1) {
		$ua = LWP::UserAgent->new; $ua->agent('Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131030');
		$response = $ua->get($flag_url.$tail.$i.$add, Cookie => $cookie);
		$html = $response->decoded_content;
		@contenido = split("\n", $html);
		foreach $linea (@contenido) {
			if ($linea =~ m/\<title\>(.*?)\<\/title\>/g) {
				$titulo = $1;
			}

		}
		if ($response->status_line =~ /404/) {
			$i = "-1";
		} else {
			$tl = length($titulo);
			$ul = $tl - $size;
			$usuario = substr($titulo,0, $ul);
			print "[+] Posible usuario encontrado ~> ".$usuario."\n";
			$i++;
		}
	}	


print "[!] Dumpeo finalizado con exito\n\n";

sub use {
print q(
	Uso: perl dumb0.pl --type=[CMS] --url=[TARGET URL] [--log]
		
	Supported: 
			SMF   	--		Simple Machine Forums
			IPB   	--		Invision Power Board
			XEN     --		Xen Foro
			VB      --		vBulletin
			myBB    --
			useBB   --
			vanilla --
			bbPress --
			WP	--		WordPress
			SPIP	--		SPIP CMS
);
}
