# File, fatture e messaggi

Il Sistema di Interscambio distingue tre tipi di file:

- 

  file FatturaPA

  : file

   

  XML

   

  firmato digitalmente conforme alle specifiche del

   

  formato della FatturaPA

  . Può contenere:

  - una fattura singola (un solo corpo fattura)
  - un lotto di fatture (più corpi fattura con la stessa intestazione).

  Per la firma del file FatturaPA consultare la sezione [Firmare la FatturaPA]().

- 

  file archivio

  : file compresso (esclusivamente nel formato

   

  zip

  ) contenente uno o più file FatturaPA.

  Il sistema elabora l’archivio controllando e inoltrando al destinatario i singoli file FatturaPA contenuti al suo interno. Di fatto i file FatturaPA vengono trattati come se venissero trasmessi singolarmente.

  Si precisa che il file archivio non deve essere firmato ma devono essere firmati, invece,tutti i file FatturaPA al suo interno.

- 

  file messaggio

  : file

   

  XML

   

  conforme a uno schema (

  xml schema

  ) descritto dal file:

   

  MessaggiTypes_v1.1.xsd

   

  scaricabile nella sezione

   

  Documentazione Sistema di Interscambio

   

  di questo sito.

  Un file messaggio può essere:

  - una **notifica di scarto**: messaggio che SdI invia al trasmittente nel caso in cui il file trasmesso (file FatturaPA o file archivio) non abbia superato i controlli previsti;
  - un **file dei metadati**: file che SdI invia al destinatario, insieme al file FatturaPA.
    Sulla base delle esperienze di gestione, appare utile chiarire la rilevanza operativa che assume il campo <*TentativiInvio*> all’interno di questo file. Si tratta di un “contatore” del numero di tentativi di inoltro al destinatario operati dal Sistema di Interscambio. Il SdI riprova l’ invio del file fattura se, in un dato periodo di tempo, non ha **riscontro certo** dell’ avvenuta consegna. Questa circostanza, in funzione del canale di ricezione utilizzato, potrebbe verificarsi anche se il file è stato effettivamente consegnato. Essa è rilevabile (anche automaticamente) proprio attraverso il campo <*TentativiInvio*>, contenuto nel file dei metadati che “accompagna” il file fattura. Pertanto ed al fine di evitare inefficienti ricicli, qualora si dovesse ricevere da SdI un file fattura con stesso identificativo SdI di uno già ricevuto e se il campo <*TentativiInvio*> presenta un valore maggiore di ‘1’, si consiglia fortemente di prendere comunque in carico il file fattura (e trattarlo a tutti gli effetti quale copia di fattura); al contrario, nel caso in cui il campo <*TentativiInvio*> dovesse presentare il medesimo valore del precedente invio, allora si tratterebbe di una eccezionale situazione di errore da segnalare a SdI;
  - una **ricevuta di consegna**: messaggio che SdI invia al trasmittente per certificare l’avvenuta consegna al destinatario del file FatturaPA;
  - una **notifica di mancata consegna**: messaggio che il SdI invia al trasmittente per segnalare la temporanea impossibilità di recapitare al destinatario il file FatturaPA;
  - una **notifica di esito committente**: messaggio facoltativo che il destinatario può inviare al SdI per segnalare l’accettazione o il rifiuto della fattura ricevuta; la segnalazione può pervenire al SdI entro il termine di 15 giorni;
  - una **notifica di esito**: messaggio con il quale il SdI inoltra al trasmittente la *notifica di esito committente* eventualmente ricevuta dal destinatario della fattura;
  - uno **scarto esito committente**: messaggio che il SdI invia al destinatario per segnalare un’eventuale situazione di non ammissibilità o non conformità della notifica di esito committente;
  - una **notifica di decorrenza termini**: messaggio che il SdI invia sia al trasmittente sia al destinatario nel caso in cui non abbia ricevuto *notifica di esito committente* entro il termine di 15 giorni dalla data della *ricevuta di consegna* o dalla data della *notifica di mancata consegna* ma solo se questa sia seguita da una *ricevuta di consegna*. Con questa notifica il SdI comunica al destinatario l’impossibilità di inviare, da quel momento in poi, *notifica di esito committente* e al trasmittente l’impossibilità di ricevere *notifica di esito*;
  - una **attestazione di avvenuta trasmissione della fattura con impossibilità di recapito**: messaggio che il SdI invia al trasmittente nei casi di impossibilità di recapito del file all’amministrazione destinataria per cause non imputabili al trasmittente (amministrazione non individuabile all’interno dell’*Indice delle Pubbliche Amministrazioni*  oppure problemi di natura tecnica sul canale di trasmissione);

- Il Sistema di Interscambio attribuisce a ogni tipologia di file messaggio una nomenclatura differente. Per maggiori approfondimenti sulla nomenclatura dei file messaggio consultare l'*Allegato B-1* del documento *Specifiche tecniche relative al Sistema di Interscambio* disponibile nella sezione [Documentazione Sistema di Interscambio]() di questo sito.

  Tutti i messaggi prodotti ed inviati dal Sistema di Interscambio, a eccezione del file dei metadati, vengono firmati elettronicamente mediante una firma elettronica di tipo XAdES-Bes.  

  La *notifica di esito committente*, unica notifica inviata dal destinatario al SdI, prevede la possibilità di essere firmata elettronicamente, sempre in modalità XAdES-Bes, in via facoltativa. Per maggiori approfondimenti sulla notifica di esito committente consultare la sezione [Esplicitare l'esito per la FatturaPA]().

  Di seguito una rappresentazione del flusso dei messaggi:






## Flusso semplificato

Esiste un flusso semplificato che può essere adottato da coloro che interagiscono con il Sistema di interscambio in veste sia di trasmittente che di ricevente tramite il medesimo canale trasmissivo; in questo caso il flusso dei messaggi subisce delle variazioni per consentire una maggiore efficienza nel processo di trasmissione delle fatture elettroniche e delle relative notifiche.

In particolare:

- il file FatturaPA,
- la notifica di esito al trasmittente

non vengono recapitati poiché sono già a disposizione di colui che li trasmette.

L'iter del processo prosegue con le tradizionali fasi del flusso come se i file fossero stati correttamente trasmessi.

L'opzione di “Flusso semplificato” è associata al canale accreditato per la trasmissione/ricezione dei file; pertanto gli Intermediari che intendono aderire al flusso semplificato, possono dichiararlo all'atto dell'accreditamento del canale nella sezione [Accreditare il canale](http://sdi.fatturapa.gov.it/SdI2FatturaPAWeb/AccediAlServizioAction.do?pagina=accreditamento_canale) di questo sito.

**NB:** l'opzione “Flusso semplificato” è disponibile per i canali trasmissivi Web-service, Porta di Dominio e FTP ma non per i canali PEC e invio web in quanto quest'ultimi due non necessitano di un accreditamento preventivo presso il Sistema di Interscambio.

Di seguito una rappresentazione del "Flusso semplificato":

