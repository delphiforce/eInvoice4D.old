Modifiche FE . 

## ver. 1.6.x

Variato lo schema XSD della fattura ordinaria con:

- introduzione del nuovo attribute “SistemaEmittente” 

  *Non servono modifiche*

- modifica del numero di occorrenze di DatiRitenuta

  *Inserita l'interfaccia: IXMLDatiRitenutaTypeList*

- modifica del type di Importo in ScontoMaggiorazioneType

  *lato gestionale (amentata la precisione del campo Importo da 4..15 a 4..21)*

- modifica della enumeration di CausalePagamentoType, TipoDocumentoType, TipoRitenutaType, NaturaType e ModalitaPagamentoType

  - TipoDocumentoType

    | codice   | descrizione                                                  |
    | -------- | ------------------------------------------------------------ |
    | TD01     | Fattura                                                      |
    | TD02     | Acconto/anticipo su fattura                                  |
    | TD03     | Acconto/anticipo su parcella                                 |
    | TD04     | Nota di credito                                              |
    | TD05     | Nota di debito                                               |
    | TD06     | Parcella                                                     |
    | **TD16** | **Integrazione fattura reverse charge interno**              |
    | **TD17** | **Integrazione/Autofattura per acquisto servizio dall’estero** |
    | **TD18** | **Integrazione per acquisto di beni intracomunitari**        |
    | **TD19** | **Integrazione/Autofattura per acquisto beni (ex art. 17 c.2 DPR 633/72)** |
    | TD20     | Autofattura per regolarizzazione e integrazione delle fatture (art. 6 c.8 d.lgs. 471/97 o art. 46 c.5 D.L. 331/93) |
    | **TD21** | **Autofattura per splafonamento**                            |
    | **TD22** | **Estrazione beni da Deposito IVA**                          |
    | **TD23** | **Estrazione beni da Deposito IVA con versamento dell’IVA**  |
    | **TD24** | **Fattura differita di cui l’art. 21, comma 4, lett. a)**    |
    | **TD25** | **Fattura differita di cui l’art. 21, comma 4,** **terzo periodo lett. b)** |
    | **TD26** | **Cessione di beni ammortizzabili e per passaggi interni (ex art.36 DPR 663/72)** |
    | **TD27** | **Fattura per autoconsumo o cessioni gratuite senza rivalsa** |

  - CausalePagamentoType

    formato alfanumerico; lunghezza di massimo 2 caratteri; i valori ammessi sono quelli della CU consultabili alla pagina delle istruzioni di compilazione del modello, ove applicabili.

    I codici da utilizzare sono quelli previsti dal modello 770S

    Riportiamo qui di seguito per comodità' la codifica prevista (aggiornata al novembre 2018)
    Fonte : http://jws.agenziaentrate.it/jws/dichiarazioni/2016/CUR16/localAppRoot/help/Quadro_AU.pdf

    - A – prestazioni di lavoro autonomo rientranti nell’esercizio di arte o professione abituale;
    - B – utilizzazione economica, da parte dell’autore o dell’inventore, di opere dell’ingegno, di brevetti industriali e di processi,
      formule o informazioni relativi ad esperienze acquisite in campo industriale, commerciale o scientifico;
    - C – utili derivanti da contratti di associazione in partecipazione e da contratti di cointeressenza, quando l’apporto è
      costituito esclusivamente dalla prestazione di lavoro;
    - D – utili spettanti ai soci promotori ed ai soci fondatori delle società di capitali;
    - E – levata di protesti cambiari da parte dei segretari comunali;
    - G – indennità corrisposte per la cessazione di attività sportiva professionale;
    - H – indennità corrisposte per la cessazione dei rapporti di agenzia delle persone fisiche e delle società di persone con esclusione delle somme maturate entro il 31 dicembre 2003, già imputate per competenza e tassate come reddito d’impresa;
    - I – indennità corrisposte per la cessazione da funzioni notarili;
    - L – redditi derivanti dall’utilizzazione economica di opere dell’ingegno, di brevetti industriali e di processi, formule e informazioni relativi a esperienze acquisite in campo industriale, commerciale o scientifico, che sono percepiti dagli aventi causa a titolo gratuito (ad es. eredi e legatari dell’autore e inventore); 
    - L1 – redditi derivanti dall’utilizzazione economica di opere dell’ingegno, di brevetti industriali e di processi, formule e informazioni relativi a esperienze acquisite in campo industriale, commerciale o scientifico, che sono percepiti da
      soggetti che abbiano acquistato a titolo oneroso i diritti alla loro utilizzazione;
    - M – prestazioni di lavoro autonomo non esercitate abitualmente;
    - M1 – redditi derivanti dall’assunzione di obblighi di fare, di non fare o permettere; 
    - M2 – prestazioni di lavoro autonomo non esercitate abitualmente per le quali sussiste l’obbligo di iscrizione alla Gestione Separata ENPAPI;
    - N – indennità di trasferta, rimborso forfetario di spese, premi e compensi erogati:
      - – nell’esercizio diretto di attività sportive dilettantistiche;
      - – in relazione a rapporti di collaborazione coordinata e continuativa di carattere amministrativo-gestionale di natura non professionale resi a favore di società e associazioni sportive dilettantistiche e di cori, bande e filodrammatiche da parte del direttore e dei collaboratori tecnici;
    - O – prestazioni di lavoro autonomo non esercitate abitualmente, per le quali non sussiste l’obbligo di iscrizione alla gestione separata (Circ. INPS n. 104/2001);
    - O1 – redditi derivanti dall’assunzione di obblighi di fare, di non fare o permettere, per le quali non sussiste l’obbligo di iscrizione alla gestione separata (Circ. INPS n. 104/2001);
    - P – compensi corrisposti a soggetti non residenti privi di stabile organizzazione per l’uso o la concessione in uso di attrezzature industriali, commerciali o scientifiche che si trovano nel territorio dello Stato ovvero a società svizzere o
      stabili organizzazioni di società svizzere che possiedono i requisiti di cui all’art. 15, comma 2 dell’Accordo tra la Comunità europea e la Confederazione svizzera del 26 ottobre 2004 (pubblicato in G.U.C.E. del 29 dicembre
      2004 n. L385/30);
    - Q – provvigioni corrisposte ad agente o rappresentante di commercio monomandatario;
    - R – provvigioni corrisposte ad agente o rappresentante di commercio plurimandatario;
    - S – provvigioni corrisposte a commissionario;
    - T – provvigioni corrisposte a mediatore;
    - U – provvigioni corrisposte a procacciatore di affari;
    - V – provvigioni corrisposte a incaricato per le vendite a domicilio; provvigioni corrisposte a incaricato per la vendita porta a porta e per la vendita ambulante di giornali quotidiani e periodici (L. 25 febbraio 1987, n. 67);
    - V1 – redditi derivanti da attività commerciali non esercitate abitualmente (ad esempio, provvigioni corrisposte per prestazioni occasionali ad agente o rappresentante di commercio, mediatore, procacciatore d’affari);
    - V2 – redditi derivanti dalle prestazioni non esercitate abitualmente rese dagli incaricati alla vendita diretta a domicilio; 
    - W – corrispettivi erogati nel 2015 per prestazioni relative a contratti d’appalto cui si sono resi applicabili le disposizioni contenute nell’art. 25-ter del D.P.R. n. 600 del 29 settembre 1973; 
    - X – canoni corrisposti nel 2004 da società o enti residenti ovvero da stabili organizzazioni di società estere di cui all’art.26-quater, comma 1, lett. a) e b) del D.P.R. 600 del 29 settembre 1973, a società o stabili organizzazioni di
      società, situate in altro stato membro dell’Unione Europea in presenza dei requisiti di cui al citato art. 26-quater, del D.P.R. 600 del 29 settembre 1973, per i quali è stato effettuato, nell’anno 2006, il rimborso della ritenuta ai
      sensi dell’art. 4 del D.Lgs. 30 maggio 2005 n. 143;
    - Y – canoni corrisposti dal 1° gennaio 2005 al 26 luglio 2005 da società o enti residenti ovvero da stabili organizzazioni di società estere di cui all’art. 26-quater, comma 1, lett. a) e b) del D.P.R. n. 600 del 29 settembre 1973, a
      società o stabili organizzazioni di società, situate in altro stato membro dell’Unione Europea in presenza dei requisiti di cui al citato art. 26-quater, del D.P.R. n. 600 del 29 settembre 1973, per i quali è stato effettuato, nell’anno
      2006, il rimborso della ritenuta ai sensi dell’art. 4 del D.Lgs. 30 maggio 2005 n. 143;
    - Z – titolo diverso dai precedenti

  - TipoRitenutaType

    | codice   | descrizione                        |
    | -------- | ---------------------------------- |
    | RT01     | Ritenuta persone fisiche           |
    | RT02     | Ritenuta persone giuridiche        |
    | **RT03** | **Contributo INPS**                |
    | **RT04** | **Contributo ENASARCO**            |
    | **RT05** | **Contributo ENPAM**               |
    | **RT06** | **Altro contributo previdenziale** |

  - NaturaType 

    | codice    | descrizione                                                  |
    | --------- | ------------------------------------------------------------ |
    | N1        | Escluse ex art. 15                                           |
    | *N2*      | *Non soggette*                                               |
    | **N2.1**  | **Non Soggette ad IVA ai sensi degli Art. da 7 a 7-septies del DPR 633/72** |
    | **N2.2.** | **Non soggette – altri casi**                                |
    | *N3*      | *Non imponibile*                                             |
    | **N3.1**  | **Non imponibile – esportazioni**                            |
    | **N3.2**  | **Non imponibile – cessioni intracomunitarie**               |
    | **N3.3**  | **Non imponibile – cessioni verso San Marino**               |
    | **N3.4**  | **Non imponibile – operazioni assimilate alle** **cessioni all’esportazione** |
    | **N3.5**  | **Non imponibile – a seguito di dichiarazioni d’intento**    |
    | **N3.6**  | **Non imponibile – altre operazioni che non concorrono** **alla formazione del plafond** |
    | N4        | Esenti                                                       |
    | N5        | Regime del margine / IVA non esposta in fattura              |
    | *N6*      | *Inversione contabile (per le operazioni in reverse charge* *ovvero nei casi di autofatturazione per acquisti extra UE di servizi* *ovvero per importazioni di beni nei soli casi previsti)* |
    | **N6.1**  | **Inversione contabile – cessione di rottami e** **altri materiali di recupero** |
    | **N6.2**  | **Inversione contabile – cessione di oro e argento puro**    |
    | **N6.3**  | **Inversione contabile – subappalto nel settore edile**      |
    | **N6.4**  | **Inversione contabile – cessione di fabbricati**            |
    | **N6.5**  | **Inversione contabile – cessione di telefoni cellulari**    |
    | **N6.6**  | **Inversione contabile – cessione di prodotti elettronici**  |
    | **N6.7**  | **Inversione contabile – prestazioni comparto edile e settori connessi** |
    | **N6.8**  | **Inversione contabile – operazioni settore energetico**     |
    | **N6.9**  | **Inversione contabile – altri casi**                        |
    | N7        | IVA assolta in altro stato UE (vendita a distanza ex art. 40 c. 3 e 4 e art. 41 c. 1 lett. b, DL 331/93; prestazione di servizi di telecomunicazioni, tele-radiodiffusione ed elettronici ex art. 7-sexies lett. f, g, art. 74-sexies DPR 633/72) |

  - ModalitaPagamentoType

    | codice   | descrizione                                |
    | -------- | ------------------------------------------ |
    | MP01     | Contanti                                   |
    | MP02     | Assegno                                    |
    | MP03     | Assegno Circolare                          |
    | MP04     | Contanti presso Tesoreria                  |
    | MP05     | Bonifico                                   |
    | MP06     | Vaglia Cambiario                           |
    | MP07     | Bollettino Bancario                        |
    | MP08     | Carta di Pagamento                         |
    | MP09     | RID                                        |
    | MP10     | RID Utenze                                 |
    | MP11     | RID Veloce                                 |
    | MP12     | RIBA                                       |
    | MP13     | MAV                                        |
    | MP14     | Quietanza Erario                           |
    | MP15     | Giroconto su conti di contabilità speciale |
    | MP16     | Domiciliazione Bancaria                    |
    | MP17     | Domiciliazione Postale                     |
    | MP18     | Bollettino di c/c postale                  |
    | MP19     | SEPA Direct Debit                          |
    | MP20     | SEPA Direct Debit CORE                     |
    | MP21     | SEPA Direct Debit B2B                      |
    | MP22     | Trattenuta su somme già riscosse           |
    | **MP23** | **PagoPA**                                 |

  

- modificato il campo complesso DatiBollo con introduzione dell’opzionalità per l’elemento ImportoBollo non più obbligatorio

  *Lato gestionale*

- introduzione del tipo String35LatinExtType

  *Utilizzato nel campo CodiceValore, sottocampo del codice articolo*. *Non influisce*

- Indicata la data di fine validità per i codici Natura N2, N3 e N6 (paragrafi 2.2 e 4.2)

  Modificata la data di entrata in vigore dei controlli con codice 00445 (Appendice 1) e 00448 (Appendice 2)

- modifica della definizione di EmailType.

  *Modificata la definizione di EmailType, che passa da semplice “string” a “normalizedstring”.*
  *Questa modifica dovrebbe permettere una sensibile riduzione degli errori legati a caratteri speciali inseriti all’interno della mail e migliorarne la verifica di correttezza. Inoltre è stato rimosso il numero minimo di caratteri accettato per l’Email, pur mantenendo a 256 la lunghezza massima supposta.*

Variato lo schema XSD dati fatture trasfrontaliere con:

- modifica della enumeration di NaturaType.

*Come affrontato nel paragrafo relativo al NaturaType della Fattura Ordinaria, sono stati introdotti nuovi codici specifici per permetterne una corretta registrazione delle fatture transfrontaliere, senza la necessità di dover ricorrere alla comunicazione periodica (Esterometro)*

## **Codici errore**

**Controlli lato gestionale**

Modificata la descrizione dell’errore 00420 sulle fatture.

Introdotti nuovi controlli sulle fatture con codici 00443, 00444, 00445, 00471, 00472, 00473, 00474

- Codice: 00473
  Descrizione: per il valore indicato nell’elemento 2.1.1.1 <TipoDocumento> non è ammesso il valore IT nell’elemento 1.2.1.1.1 <IdPaese> (i valori TD17, TD18 e TD19 del tipo documento non ammettono l’indicazione in fattura di un cedente italiano)
  (vale solo per le fatture ordinarie)

- Codice: 00474
Descrizione: per il valore indicato nell’elemento 2.1.1.1 <TipoDocumento> non sono ammesse linee di dettaglio con l’elemento 2.2.1.12 <AliquotaIVA> contenente valore zero (nel tipo documento ‘autofattura per splafonamento’ tutte le linee di dettaglio devo avere un’aliquota IVA diversa da zero)
(vale solo per le fatture ordinarie)
- Modificati i criteri di controllo per gli errori 00323, 00404 e 00409 sulle fatture.
- Modificata la descrizione dell’errore 00400 sui dati fattura.
- Introdotti nuovi controlli sui dati fattura con codici 00321, 00325
- Codice: 00448 (controllo in vigore dal primo gennaio 2021)
  Descrizione: non è più ammesso il valore generico N2, N3 o N6 come codice natura dell’operazione (a partire dal primo gennaio 2021 non è più consentito utilizzare i codici natura ‘padre’ ma solo quelli di dettaglio, laddove previsti; in particolare non sono più utilizzabili i codici N2, N3 e N6)

(paragrafi modificati: 2.1.2 - 2.1.7 – 2.1.8 – 2.2.9.1 – 2.2.10.1 – 2.2.10.2 – 2.2.12 - 4.2.1.2.2 – 4.2.1.3.2 – Appendice 1 – Appendice 2 – Appendice 3 – Appendice 4 – Appendice 5)

