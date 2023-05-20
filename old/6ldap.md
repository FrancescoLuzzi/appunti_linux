LDAP-> specilizzato nella condivisione di informazioni di USERS ed i file di configurazione, per questo è usato da PAM e NSS
(funziona come una rubrica telefonica con #scritture<<#letture)

Nasce come sistema per organizzare i dati di persone e
risorse materiali all'interno di un'organizzazione

Un sistema correttamente funzionante dipende da parecchi file di configurazione, ma:
    – in una rete possono esserci centinaia di macchine che hanno gli stessi file di configurazione
    – aggiungere un utente, aggiungere un host, cambiare un parametro di funzionamento di un demone, vuol dire cambiare
    coerentemente centinaia di file di configurazione
Allora, nasce l'esigenza di condividere queste informazioni tra sistemi diversi e l'approccio a file diventa inefficiente
Occorre trovare un database centralizzato, in particolare
    – servizi di templating e configuration management
    – servizi centralizzati di autenticazione

Tra i due: librerie con interfacce standard
– libnss-ldap: permette di usare un db remoto LDAP come sorgente di nomi di qualsiasi tipo (utenti, gruppi, host, ...)
– libpam-ldap: permette di accedere a un db remoto LDAP per autenticare utenti e ricavare regole di autorizzazione

La base di dati della directory può essere un qualsiasi sistema di archiviazione,
è definita un'interfaccia (DBI – DataBase Interface);
è sufficiente implementarla con un modulo per pilotare il backend più adatto.

DBI gestisce una serie di entry (o object) con una serie di "attribute" che implicano un type ed uno o più value.
Ogni entry ha un DN (Distinguish name) diviso in RDN e BDN ed una objectClass

La struttura risultante è chiamata DIT (Dir Information Tree) e rappresenta il modo con cui viene esposto
il DataBase gestito dalla DBI. Gerarchica non Relazionale (DIT!=SQL)
Le entry sono gerarchicamente legate perchè:
    -Permette di costruire direttamente riferimenti ai dati
    -Permette un facile partizionamento (amministrazione, controllo accessi, collocazione fisica)
    -Vincola a una determinata vista dell'organizzazione (che può comunque essere anche piatta)

Una entry è una collezione di attributi, si specifica direttamente il valore etichettato dal tipo;
ce ne sono due sempre presenti
– dn (distinguished name)
– objectClass (una o più – altri dettagli in seguito)

Si usa uno schema
– insieme di regole che descrivono i dati immagazzinati
– contiene due tipi di definizioni: objectClass e attributeType
1)Ogni entry è modellata su una o più objectClass
    – vincola i tipi di attributi obbligatoriamente o facoltativamente presenti nella entry
2)Ogni attributo ha un attributeType
    – definisce i tipi di dato e le regole per compararli

La stringa tipoAttributo=valoreAttributo scelta è il Relative Distinguished Name della entry (RDN)
Il nome del nodo dell'albero a cui "appendere" la entry è il Base Distinguished Name della entry (BDN)
Il Distinguished Name (DN) è il nome univoco ottenuto concatenando i due DN=RDN+BDN {dn:| uid:franc,|[+] ou:People, dc:labammsis}

Definizione dei tipi di attributo
Un attributeType specifica separatamente:
    -SYNTAX, il vero e proprio tipo di dato nativo
    -Matching Rules (ORDERING, EQUALITY, SUBSTRING)
    -Eventuali vincoli d'uso
    -Eventuali dipendenze gerarchiche(SUP <altro attributeType>)

Esistono numerosissimi attributeType definiti da vari Internet standard per gli usi più comuni.
Tra i più comuni:
    • uid userId
    • cn common name
    • sn surname
    • dc domain component
    • o organization
    • ou organization unit
    • c country
    • cn common name

I tipi di attributi fondamentali per l'organizzazione delle entry LDAP per l'autenticazione di Utenti sono dc, ou, cn, uid
dc(dominio) --> ou (gruppi) --> uid (id per ogni Utente) -- cn (Nome dell'utente)

Classi
Lo scopo essenziale delle objectClass è di elencare:
– quali attributi deve avere una entry: MUST
– quali attributi può avere una entry: MAY

Le classi possono essere di tre tipi
– ABSTRACT, servono per creare una tassonomia di categorie di
oggetti, ancora troppo astratte per poter originare entry
– STRUCTURAL, servono per descrivere categorie di oggetti concreti
– AUXILIARY, servono per descrivere collezioni di attributi non
direttamente collegati a specifiche categorie di oggetti,
ma che possono essere aggiunti per arricchire il
contenuto informativo di una entry

Le classi possono essere definite gerarchicamente
SUP <altra objectClass>, ereditando tutti i MUST e MAY della classe superiore

!!!In ogni entry:
    – DEVE essere menzionata UNA E UNA sola classe strutturale
    – POSSONO essere menzionate più classi ausiliarie

ldap:/// socket network qualsiasi
ldapi:/// socket locale
ldaps:/// socket con connessione protetta da TLS

Inserimento di nuove nell'albero di configurazione di LDAP si fa mettendo {-Y EXTERNAL} al posto di (-x -D "cn=admin,dc=labammsis" -w gennaio.marzo)
~ldapadd -Y EXTERNAL -H ldapi:/// -f filesystem.ldif
~ldapmodify -Y EXTERNAL -H ldapi:/// -f filesystem.ldif

Protocollo applicativo su TCP
– porta 389 (standard)
– porta 636 (over TLS)

La ricerca deve specificare
– come tutte le operazioni, un bind DN (-D)
    • equivale all'utente con cui autenticarsi sul server LDAP
– un base DN (-b)
    • il punto del DIT da cui iniziare la ricerca
– uno scope (-s)
    • quanto estendere la ricerca
    • sub – intero sottoalbero, il default
    • one – le sole entry figlie dirette del base DN
    • base – il solo nodo base DN
– eventualmente un filtro '(&(nome_attr=valore)(nome_attr2=valore2))'
    • ricerca per contenuto della entry anziché per posizione
    • espressioni logiche in notazione prefissa

Operazioni e strumenti
-per la ricerca
~ldapsearch -H ldap://ip/ -x{simple auth} -LLL{output formatting as ldif file} -b {research base} dc=labammsis [-Y EXTERNAL {mi logo come root} | -D "dn to bind to"] [ -s base | one | {sub}default  (Specify the scope of the search)] -w password [filtro]
(ES. ldapsearch -x -LLL -H ldap://ip/ -D "cn=admin,dc=labammsis" -b dc=labammsis {base di ricerca} -w gennaio.marzo '(&(nome_attr=valore)(nome_attr2=valore2)(objectClass=*))'

~ldapsearch −x −LLL −D cn=admin,dc=labammsis −b ou=People,dc=labammsis -s one −w gennaio.marzo −H ldapi:/// 'FILTRO'

[filtro]:

'(|(objectClass=group)(&(ou:dn:=Chicago)(!(ou:dn:=Wrigleyville))))'== 
if( (objectClass==group) || ( (ou in dn==Chicago) && !(ou in dn=Wrigleyville) ) )

uidNumber>=num
uidNumber<=num

uid=*dave* == uid.contains("dave")

- per l'aggiunta
~ldapadd -x -D {come voglio autenticarmi} "cn=admin,dc=labammsis" -w pass_admin [ -f file_ldif_da_inserire ]{dn: ___
													     objectClass: ----
													     attr: valore}
    • se omesso -f usa stdin (ssh 10.20.20.254 "cat /tmp/dir.backup | ldapadd -x -D cn=admin,dc=labammsis −b dc=labammsis −w gennaio.marzo)

- per la modifica
~ldapmodify -x -D {come voglio autenticarmi} "cn=admin,dc=labammsis" -w pass_admin [ -f file_ldif_modifica ]{dn: ___
													     changetype: (add|delete|modify)
												         replace: attr {\ attr: new_val}
													     add: attr {\ attr:val}
													     delete: attr}		
    • stessi parametry ldapadd
    – varietà di casi
        • aggiunta/modifica/rimozione attributo

- per la rimozione

~ldapdelete -x -D "cn=admin,dc=labammsis" -w pass_admin -> da una pipe {echo "dn: cn=dave,ou=People,dc=labammsis" | ldapdelete...  }

-modifica password
    ~ldappasswd -D cn=admin,dc=labammsis -w gennaio.marzo uid=dave,ou=People,dc=labammsis -s $PASSWORD_NUOVA



#funzioni per LDAP

#usage change_pass uid passwd
~function change_pass(){
    ldappasswd -D cn=admin,dc=labammsis -w gennaio.marzo uid=$1,ou=People,dc=labammsis -s $2
}

ldapsearch -x -LLL -H ldap://ip/ -D "cn=admin,dc=labammsis" -b dc=labammsis -w gennaio.marzo '(&(nome_attr=valore)(nome_attr2=valore2))'

ldapadd -x -D "cn=admin,dc=labammsis" -w gennaio.marzo -f file.ldif
ldapmodify -x -D "cn=admin,dc=labammsis" -w gennaio.marzo -f file.ldif


come interagire con le diverse funzioni di ldap:

#togliere tutti gli elementi dentro ou=People,dc=labammsis
ldapsearch −x −LLL −D cn=admin,dc=labammsis −b ou=People,dc=labammsis -s one −w gennaio.marzo −H ldap://ip/ |
egrep ^dn: | ldapdelete -x -D cn=admin,dc=labammsis −b dc=labammsis −w gennaio.marzo −H ldap://ip/

echo "dn: $1" >/tmp/mod.ldif                      
echo "changetype: modify">>/tmp/mod.ldif
echo "replace: attr">>/tmp/mod.ldif
echo "attr=...">>/tmp/mod.ldif
ldapmodify -x -D "cn=admin,dc=labammsis" -w gennaio.marzo  /tmp/mod.ldif
rm /tmp/mod.ldif


(echo "dn: $1"
echo "changetype: delete") | ldapmodify -x -D "cn=admin,dc=labammsis" -w gennaio.marzo