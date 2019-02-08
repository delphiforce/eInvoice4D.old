# eInvoice4D

#### DelphiForce

Libreria per la fatturazione elettronica per Delphi 

**Agg. 2019.02.08 - *Release: Julius Verne***

- aggiunte alcune utility come il 
  - *Sanitizer* per ripulire i valori prima della generazione dell'XML
  - *P7mExtractor* per aggiungere una libreria dei file firmati esterna
  - *Logger " su file, grazie a Paolo Filippini, 
    Di default il log è salvato in *%APPDATA%/LogFatturaElettronica/log/YYYYMM/LogFatturaElettronica_YYYYMMDD_user.log*  
- inserito il metodo *ei.SetDelay(ms)* per gestire una pausa in ms tra le diverse chiamate di *invio fatture / ricezione notifiche* verso l'intermediario
- impostazioni base per la ricezione di fatture di acquisto
- aggiunta prima raccolta documentazione per lo *scontrino elettronico*



**Agg. 2018.12.12 - *Release: Santa Lucia***

- aggiunta cartella docs con la documentazione recuperata dai siti dell'AdE (Agenzia delle Entrate)
- terminata la gestione esiti da intermediario per il ciclo attivo
- aggiunta funzionalità isPA per verificare se la fattura è della Pubblica Amministrazione
- aggiornato con gestione esiti Demo
- aggiornato con gestione esiti package eInvoice4D e eMiniInvoice4D (per versioni di Delphi antecedenti XE)
- aggiornato con gestione esiti eInvoiceService



Distribuita con Licenza LGPL ver. 3 https://www.gnu.org/licenses/lgpl-3.0.en.html



Delphi Force Developer Team

- Antonio Polito
- Carlo Narcisi
- Fabio Codebue
- Marco Mottadelli
- Maurizio del Magno
- Omar Bossoni
- Thomas Ranzetti