<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:a="http://www.fatturapa.it/sdi/richiesta/v2.0">
	<xsl:output version="4.0" method="html" indent="no" encoding="UTF-8" doctype="html" doctype-system="http://www.w3.org/TR/html4/loose.dtd"/>
	<xsl:param name="SV_OutputFormat" select="'HTML'"/>
	<xsl:variable name="XML" select="/"/>
	<xsl:decimal-format name="format1" grouping-separator="." decimal-separator=","/>
	
	<xsl:template name="T_TitoloRichiesta">
		<xsl:choose>
			<xsl:when test="a:Richiesta/TipoRichiesta='10' or a:Richiesta/TipoRichiesta='11' or a:Richiesta/TipoRichiesta='12'">
				Accordo di servizio
			</xsl:when>
			<xsl:when test="a:Richiesta/TipoRichiesta='13' or a:Richiesta/TipoRichiesta='14' or a:Richiesta/TipoRichiesta='15'">
				Revoca canale accreditato
			</xsl:when>
			<xsl:when test="a:Richiesta/TipoRichiesta='20'">
				Emissione certificati per accordo servizio
			</xsl:when>
			<xsl:otherwise>
				Documento sconosciuto
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="T_ListaServizi">
		<ul>
		<xsl:if test="a:Richiesta/Dati/Accreditamento/SDICoop/Trasmissione">
			<li><em>SdICoop - Invio della FatturaPA tramite Web Service</em></li>
		</xsl:if>
		<xsl:if test="a:Richiesta/Dati/Accreditamento/SDICoop/Ricezione">
			<li><em>SdICoop - Ricezione della FatturaPA tramite Web Service</em></li>
		</xsl:if>
		<xsl:if test="a:Richiesta/Dati/Accreditamento/SDICoop/DatiFattura">
			<li><em>SdICoop - File Dati trasmessi tramite Web Service</em></li>
		</xsl:if>

		<xsl:if test="a:Richiesta/Dati/Accreditamento/SPCoop/Trasmissione">
			<li><em>SPCoop - Invio della FatturaPA tramite Porta di Dominio</em></li>
		</xsl:if>
		<xsl:if test="a:Richiesta/Dati/Accreditamento/SPCoop/Ricezione">
			<li><em>SPCoop - Ricezione della FatturaPA tramite Porta di Dominio</em></li>
		</xsl:if>
		<xsl:if test="a:Richiesta/Dati/Accreditamento/SPCoop/DatiFattura">
			<li><em>SPCoop - File Dati trasmessi tramite Porta di Dominio</em></li>
		</xsl:if>

		<xsl:if test="a:Richiesta/Dati/Accreditamento/SDIFTP">
			<li><em>SDIFTP - Invio e Ricezione della FatturaPA e Trasmissione Dati Fattura tramite FTP</em></li>
		</xsl:if>		
		</ul>
	</xsl:template>
	
	<xsl:template name="T_SDICoop">
		<p><xsl:value-of select="Descrizione" /></p>
		
		<ul>
			<li>
				Nome WSDL:
				<span><xsl:value-of select="NomeWSDL" /></span>
			</li>
			<li>
				Dimensione massima messaggio:
				<span><xsl:value-of select="DimensioneMaxMessaggio" /></span>
			</li>
			<li>
				Endpoint:
				<span><xsl:value-of select="EndPoint" /></span>
			</li>
			<li>
				Endpoint di test:
				<span><xsl:value-of select="EndPointTest" /></span>
			</li>
			<li>
				Versione:
				<span><xsl:value-of select="Versione" /></span>
			</li>
		</ul>	
	</xsl:template>

	<xsl:template name="T_SPCoop_Ricezione">
		<p><xsl:value-of select="Descrizione" /></p>
		<ul>
			<li>
				Nome WSDL:
				<span><xsl:value-of select="NomeWSDL" /></span>
			</li>
			<li>
				Dimensione massima messaggio:
				<span><xsl:value-of select="DimensioneMaxMessaggio" /></span>
			</li>
			<li>
				Endpoint:
				<span><xsl:value-of select="indirizzoPorta" /></span>
			</li>
			<li>
				Endpoint di test:
				<span><xsl:value-of select="EndPointTest" /></span>
			</li>
			<li>
				Versione:
				<span><xsl:value-of select="Versione" /></span>
			</li>
		</ul>	
	</xsl:template>

	<xsl:template name="T_SPCoop">
		<p><xsl:value-of select="Descrizione" /></p>
		<ul>
			<li>
				Dimensione massima messaggio:
				<span><xsl:value-of select="DimensioneMaxMessaggio" /></span>
			</li>
			<li>
				Versione:
				<span><xsl:value-of select="Versione" /></span>
			</li>
		</ul>	
	</xsl:template>
	
	<xsl:template name="T_Riferimento">
		<ul>
			<xsl:if test="Cognome">
				<li>
					Cognome:
					<span><xsl:value-of select="Cognome" /></span>
				</li>
			</xsl:if>
			<xsl:if test="Nome">
				<li>
					Nome:
					<span><xsl:value-of select="Nome" /></span>
				</li>
			</xsl:if>
			<xsl:if test="Telefono">
				<li>
					Telefono:
					<span><xsl:value-of select="Telefono" /></span>
				</li>
			</xsl:if>
			<xsl:if test="Email">
				<li>
					Email:
					<span><xsl:value-of select="Email" /></span>
				</li>
			</xsl:if>
			<xsl:if test="OrarioDisponibile">
				<li>
					Orario Disponibile:
					<span><xsl:value-of select="OrarioDisponibile" /></span>
				</li>
			</xsl:if>
			<xsl:if test="CodiceFiscale">
				<li>
					Codice Fiscale:
					<span><xsl:value-of select="CodiceFiscale" /></span>
				</li>
			</xsl:if>
		</ul>
	</xsl:template>

	<xsl:template match="/">
		<html>
			<head>
				<title>
					<xsl:call-template name="T_TitoloRichiesta" />
				</title>
				<meta http-equiv="X-UA-Compatible" content="IE=edge" />
				<style type="text/css">
					#accordo-container { width: 100%; position: relative; font-family: sans-serif; font-size: 14px !important; }

					#accordo { margin-left: auto; margin-right: auto; max-width: 1280px; min-width: 930px; padding: 0; }
					#accordo h1 { padding: 30px 0; margin: 0; font-size: 2em; text-align: center; }
					#accordo h2 { padding: 30px 0 10px 0; margin: 0; font-size: 1.8em; text-align: center; }
					#accordo h3 { padding: 20px 0 0 0; margin: 0; font-size: 1.3em; font-variant: small-caps;}
					#accordo h4 { padding: 20px 0 0 0; margin: 0; font-size: 1.1em; font-style: italic; font-weight: normal; }
					#accordo h5 { padding: 15px 0 0 0; margin: 0; font-size: 1em; font-style: italic; }
					#accordo ul { list-style-type: none; margin: 0 !important; padding: 15px 0 0 40px !important; }
					#accordo ul li { padding: 3px 0; clear: both; }
					#accordo ul li span { font-weight: bold; }
					#accordo div { padding: 0; margin: 0; }
					#accordo ul.elenco { list-style-type: upper-roman; }

					#accordo div.page {
						background-color: #fff !important;
						position: relative;
	
						margin: 20px 0
						50px 0;
						padding: 60px;
	
						background: -moz-linear-gradient(0% 0 360deg, #FFFFFF, #F2F2F2 20%, #FFFFFF) repeat scroll 0 0 transparent;
						border: 1px solid #CCCCCC;
						-webkitbox-shadow: 0 0 10px rgba(0, 0, 0,
						0.3);
						-mozbox-shadow: 0
						0 10px rgba(0, 0, 0, 0.3);
						box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
	
						background: url('logo_sdi_trasparente.jpg') 98% 50px no-repeat;
					}
					
					#accordo div.header { padding: 50px 0 0 0; margin: 0; font-size: .8em; text-align: center; color: #777777; }
					#accordo div.footer { padding: 50px 0 0 0; margin: 0; font-size: .8em; text-align: center; color: #777777; }
					#accordo-container .versione { font-size: .8em; float:right; color: #777777; }
					#accordo .descrizione { color: #606060; font-size: .9em; font-weight: normal; }
				</style>
			</head>
			<body>
				<div id="accordo-container">
					<div id="accordo">
						<div class="page">
						
							<div class="versione">
								Versione <xsl:value-of select="a:Richiesta/@versione"/>
							</div>
							
							<h1>
								<xsl:call-template name="T_TitoloRichiesta" />
							</h1>
							
							<div id="tipo_richiesta">
								<p>								
									Tra <strong><xsl:value-of select="a:Richiesta/Proponente/Denominazione" /></strong>, 
									di seguito &quot;proponente&quot; e <strong><xsl:value-of select="a:Richiesta/Sottoscrittore/Denominazione" /></strong>, 
									di seguito &quot;sottoscrittore&quot; relativamente a:
								</p>
							</div>

							<xsl:call-template name="T_ListaServizi" />
							
							<div id="descrizione">
								<p>
									<xsl:value-of select="a:Richiesta/Dati/Accreditamento/Descrizione" />
										<xsl:value-of select="a:Richiesta/Descrizione" />
								</p>	
							</div>
							
							<xsl:if test="a:Richiesta/IdRichiestaCorrelata">
							<h3>Accordo di servizio</h3>
							<ul>
								<li>Numero: <span><xsl:value-of select="a:Richiesta/IdRichiestaCorrelata" /></span></li>
							</ul>
							</xsl:if>

							<div id="proponente">
								<h3>Proponente</h3>
								<ul>
									<xsl:for-each select="a:Richiesta/Proponente">
										<xsl:if test="SitoInternet">
											<li>
												Sito Internet:
												<span><xsl:value-of select="SitoInternet" /></span>
											</li>
										</xsl:if>
										<xsl:if test="CasellaPEC">
											<li>
												Casella PEC:
												<span><xsl:value-of select="CasellaPEC" /></span>
											</li>
										</xsl:if>
									</xsl:for-each>
								</ul>
							</div>

							<div id="sottoscrittore">								
								<h3>Sottoscrittore</h3>
								<ul>
									<xsl:for-each select="a:Richiesta/Sottoscrittore">
										<xsl:if test="CodiceFiscale">
											<li>
												Codice Fiscale:
												<span><xsl:value-of select="CodiceFiscale" /></span>
											</li>
										</xsl:if>
										<xsl:if test="CasellaPEC">
											<li>
												Casella PEC:
												<span><xsl:value-of select="CasellaPEC" /></span>
											</li>
										</xsl:if>
										<xsl:if test="SitoInternet">
											<li>
												Sito Internet:
												<span><xsl:value-of select="SitoInternet" /></span>
											</li>
										</xsl:if>
									</xsl:for-each>
								</ul>
								
								<xsl:if test="a:Richiesta/Sottoscrittore/RiferimentoAccordo">
									<div id="riferimento">
										<h4>Riferimento Accordo</h4>
										<xsl:for-each select="a:Richiesta/Sottoscrittore/RiferimentoAccordo">
											<xsl:call-template name="T_Riferimento" />
										</xsl:for-each>
									</div>
								</xsl:if>
								
								<xsl:if test="a:Richiesta/Sottoscrittore/RiferimentoTecnico">
									<div id="riferimento-tecnico">
										<h4>Riferimento Tecnico</h4>
										<xsl:for-each select="a:Richiesta/Sottoscrittore/RiferimentoTecnico">
											<xsl:call-template name="T_Riferimento" />
										</xsl:for-each>
									</div>
								</xsl:if>
							</div>
							
							<!-- ACCREDITAMENTO CANALE -->
							<xsl:if test="a:Richiesta/Dati/Accreditamento">
							
								<div id="attivazione-avvio-revoca-servizio">
									<h3>Attivazione, avvio e revoca del servizio</h3>
									<p>
										<xsl:value-of select="a:Richiesta/Dati/Accreditamento/AttivazioneAvvioRevocaServizio" />
									</p>
								</div>
								
															
								<div id="disponibilita-servizio">
									<h3>Disponibilita' del servizio</h3>
									<p>
										<xsl:value-of select="a:Richiesta/Dati/Accreditamento/Disponibilita" />
									</p>
								</div>
								
								<xsl:if test="a:Richiesta/Dati/Accreditamento/SDICoop">
									<div id="sicurezza-sdicoop">
										<h3>Sicurezza</h3>
										<p>
											<xsl:value-of select="a:Richiesta/Dati/Accreditamento/SDICoop/Sicurezza" />
										</p>
									</div>
								</xsl:if>
							</xsl:if>
						
						
							<xsl:if test="a:Richiesta/Dati/Accreditamento">
							<div id="servizi">
								
								<h2>Descrizione dei servizi operativi</h2>

								<!-- SERVIZIO SDICoop -->								
								<xsl:for-each select="a:Richiesta/Dati/Accreditamento/SDICoop/Trasmissione">
									<div id="trasmissione-sdicoop">
										<xsl:for-each select="TrasmissioneFatture">
											<h4>Web Service &quot;TrasmissioneFatture&quot;</h4>
											<xsl:call-template name="T_SDICoop" />
										</xsl:for-each>

										<xsl:for-each select="SdIRiceviFile">
											<h4>Web Service &quot;SdIRiceviFile&quot;</h4>
											<xsl:call-template name="T_SDICoop" />
										</xsl:for-each>
									</div>
								</xsl:for-each>
								
								<xsl:for-each select="a:Richiesta/Dati/Accreditamento/SDICoop/Ricezione">
									<div id="ricezione-sdicoop">
										<xsl:for-each select="SdIRiceviNotifica">
											<h4>Web Service &quot;SdIRiceviNotifica&quot;</h4>
											<xsl:call-template name="T_SDICoop" />
										</xsl:for-each>
										
										<xsl:for-each select="RicezioneFatture">
											<h4>Web Service &quot;RicezioneFatture&quot;</h4>
											<xsl:call-template name="T_SDICoop" />	
										</xsl:for-each>
									</div>
								</xsl:for-each>

								<xsl:for-each select="a:Richiesta/Dati/Accreditamento/SDICoop/DatiFattura">
									<div id="datifattura-sdicoop">																	
										<xsl:for-each select="TrasmissioneDatiFattura">
											<h4>Web Service &quot;SDITrasmissioneFile&quot;</h4>
											<xsl:call-template name="T_SDICoop" />
										</xsl:for-each>
										<!--		
										<xsl:for-each select="EsitoDatiFattura">
											<h4>Web Service &quot;Esito Dati fattura&quot;</h4>
											<xsl:call-template name="T_SDICoop" />
										</xsl:for-each>
										-->
									</div>
								</xsl:for-each>

								<!-- SERVIZIO SPCoop -->		
								<xsl:if test="a:Richiesta/Dati/Accreditamento/SPCoop/Trasmissione">
									<div id="servizio-spcoop">
										<h4>Web Service &quot;TrasmissioneFatture&quot;</h4>
											<p>
												<xsl:value-of select="a:Richiesta/Dati/Accreditamento/SPCoop/Trasmissione/Descrizione" />
											</p>
			
										<ul>																				
											<li>
												Nome WSDL:
												<span>TrasmissioneFatture_v1.1.wsdl</span>
											</li>
											
											<li>
												Dimensione massima messaggio:
												<span><xsl:value-of select="a:Richiesta/Dati/Accreditamento/SPCoop/Trasmissione/DimensioneMaxMessaggio" /></span>
											</li>
											
											<li>
												Endpoint:
												<span><xsl:value-of select="a:Richiesta/Dati/Accreditamento/SPCoop/IndirizzoPorta" /></span>
											</li>
											
											<li>
												Endpoint di test:
												<span><xsl:value-of select="a:Richiesta/Dati/Accreditamento/SPCoop/IndirizzoPortaTest" /></span>
											</li>
											
											<li>
												Versione:
												<span><xsl:value-of select="a:Richiesta/Dati/Accreditamento/SPCoop/Trasmissione/Versione" /></span>
											</li>
										</ul>
									</div>
								</xsl:if>
																			
								<xsl:if test="a:Richiesta/Dati/Accreditamento/SPCoop/Ricezione">
									<div id="ricezione-spcoop">
										<h4>Web Service &quot;RicezioneFatture&quot;</h4>
											<p>
												<xsl:value-of select="a:Richiesta/Dati/Accreditamento/SPCoop/Ricezione/Descrizione" />
											</p>
			
										<ul>																				
											<li>
												Nome WSDL:
												<span>RicezioneFatture_v1.0.wsdl</span>
											</li>
											
											<li>
												Dimensione massima messaggio:
												<span><xsl:value-of select="a:Richiesta/Dati/Accreditamento/SPCoop/Ricezione/DimensioneMaxMessaggio" /></span>
											</li>
											
											<li>
												Endpoint:
												<span><xsl:value-of select="a:Richiesta/Dati/Accreditamento/SPCoop/IndirizzoPorta" /></span>
											</li>
											
											<li>
												Endpoint di test:
												<span><xsl:value-of select="a:Richiesta/Dati/Accreditamento/SPCoop/IndirizzoPortaTest" /></span>
											</li>
											
											<li>
												Versione:
												<span><xsl:value-of select="a:Richiesta/Dati/Accreditamento/SPCoop/Trasmissione/Versione" /></span>
											</li>
										</ul>
									</div>
								</xsl:if>
								
								<xsl:if test="a:Richiesta/Dati/Accreditamento/SPCoop/DatiFattura">
									<div id="datifatture-spcoop">
										<h4>Web Service &quot;SDITrasmissioneFile&quot;</h4>
											<p>
												<xsl:value-of select="a:Richiesta/Dati/Accreditamento/SPCoop/DatiFattura/Descrizione" />
											</p>
			
										<ul>																				
											<li>
												Nome WSDL:
												<span>SdITrasmissioneFile_v2.0.wsdl</span>
											</li>
											
											<li>
												Dimensione massima messaggio:
												<span><xsl:value-of select="a:Richiesta/Dati/Accreditamento/SPCoop/DatiFattura/DimensioneMaxMessaggio" /></span>
											</li>
											
											<li>
												Endpoint:
												<span><xsl:value-of select="a:Richiesta/Dati/Accreditamento/SPCoop/IndirizzoPorta" /></span>
											</li>
											
											<li>
												Endpoint di test:
												<span><xsl:value-of select="a:Richiesta/Dati/Accreditamento/SPCoop/IndirizzoPortaTest" /></span>
											</li>
											
											<li>
												Versione:
												<span><xsl:value-of select="a:Richiesta/Dati/Accreditamento/SPCoop/Trasmissione/Versione" /></span>
											</li>
										</ul>
									</div>
								</xsl:if>
								
								<!-- SERVIZIO SDIFTP -->								
								<xsl:if test="a:Richiesta/Dati/Accreditamento/SDIFTP">
									<div id="trasmissione-ricezione-ftp">
										<h3>Servizio di invio della fattura via FTP</h3>
										<ul>																				
											<li>
												Id Nodo:
												<span><xsl:value-of select="a:Richiesta/Sottoscrittore/CodiceFiscale" /></span>
											</li>
											
											<li>
												Indirizzo Ip:
												<span><xsl:value-of select="a:Richiesta/Dati/Accreditamento/SDIFTP/IndirizzoIp" /></span>
											</li>
											
											<li>
												Versione:
												<span><xsl:value-of select="a:Richiesta/Dati/Accreditamento/SDIFTP/Versione" /></span>
											</li>
										</ul>
									</div>
								</xsl:if>
                    		</div>
                    	</xsl:if>
                    	
                    	<!-- CSR Solo per Accrediamento e Rigenerazione certificati -->
                    	<xsl:if test="a:Richiesta/TipoRichiesta = '10' or a:Richiesta/TipoRichiesta = '13' or a:Richiesta/TipoRichiesta = '20'">
						
                    		<xsl:if test="a:Richiesta/Dati/CSRClientTest">
								<h3>CSR (Certificate Signing Request)</h3>
								<p>
									Il sottoscrittore fornisce  al proponente le seguenti 
									CSR necessarie per la generazione dei certificati
								</p>
								
								<h4>CSR certificato client di test</h4>
								<xsl:for-each select="a:Richiesta/Dati/CSRClientTest">
									<ul>	
										<li>
											Nome della CSR:
											<span><xsl:value-of select="NomeCsr" /></span>
										</li>
										<li>
											CN contenuto nella CSR:
											<span><xsl:value-of select="CN" /></span>
										</li>
									</ul>
								</xsl:for-each>
							</xsl:if>
						
							<xsl:if test="a:Richiesta/Dati/CSRServerTest">
								<h4>CSR certificato server di test</h4>
								<xsl:for-each select="a:Richiesta/Dati/CSRServerTest">
									<ul>	
										<li>
											Nome della CSR:
											<span><xsl:value-of select="NomeCsr" /></span>
										</li>
										<li>
											CN contenuto nella CSR:
											<span><xsl:value-of select="CN" /></span>
										</li>
									</ul>
								</xsl:for-each>
							</xsl:if>

							<h4>CSR certificato client di produzione</h4>
							<xsl:for-each select="a:Richiesta/Dati/CSRClientProd">
								<ul>	
									<li>
										Nome della CSR:
										<span><xsl:value-of select="NomeCsr" /></span>
									</li>
									<li>
										CN contenuto nella CSR:
										<span><xsl:value-of select="CN" /></span>
									</li>
								</ul>
							</xsl:for-each>
							
							<h4>CSR certificato server di produzione</h4>
							<xsl:for-each select="a:Richiesta/Dati/CSRServerProd">
								<ul>	
									<li>
										Nome della CSR:
										<span><xsl:value-of select="NomeCsr" /></span>
									</li>
									<li>
										CN contenuto nella CSR:
										<span><xsl:value-of select="CN" /></span>
									</li>
								</ul>
							</xsl:for-each>					
						</xsl:if>
						
						<!-- Duplice Ruolo -->
						<xsl:if test="a:Richiesta/Dati/Accreditamento/DupliceRuolo = 'Si'">				
							<div id="duplice-ruolo">
								<h3>Flusso semplificato</h3>
								<p>
									Il sottoscrittore dichiara di sottoscrivere l’opzione &quot;flusso semplificato&quot;, 
									come descritta  sul sito www.fatturapa.gov.it 
									nella sezione &quot;Strumenti - Accreditare il canale&quot;. In virtù di tale 
									opzione il sottoscrittore dichiara di non volere ricevere tramite il servizio oggetto 
									del presente accordo le medesime fatture trasmesse al SdI per il tramite del servizio 
									oggetto del medesimo accordo.
								</p>
							</div>
						</xsl:if>
						
						<!-- Allegati -->
						<xsl:if test="a:Richiesta/Allegati and count(a:Richiesta/Allegati/*) > count(a:Richiesta/Allegati/*[@hidden='true'])">
             			<div class="allegato">
						
							<!-- Controllo visibili -->	
                   			<h3>Allegati</h3>
                   			<p>
                   				Fanno parte integrante del presente accordo i seguenti documenti:
                   			</p>
                   			
							<ul class="elenco">	
                   			<xsl:for-each select="a:Richiesta/Allegati/Allegato">
								<xsl:variable name="HIDDEN_ATTACHMENT">
									<xsl:value-of select="@hidden" />
								</xsl:variable>
                   			
                   				<xsl:if test="$HIDDEN_ATTACHMENT!='true'"> 
									<li>
										<span><xsl:value-of select="NomeFile" /></span>
										<xsl:if test="Descrizione">
											<div class="descrizione"><xsl:value-of select="Descrizione" /></div>
										</xsl:if>
									</li>
                   				</xsl:if>
							</xsl:for-each>
							</ul>
							
							<!--ul class="elenco">	
								<li>
									<span>DatiFatturaTypes_v1.0.xsd</span>
								</li>
								<li>
									<span>SdIRiceviFileDatiFatture_v1.0.wsdl</span>
								</li>
								
							</ul>
							-->
						</div>
						</xsl:if>
						
						<!--div id="disconoscimento">
							<p style="padding-top: 2em;">
								<xsl:value-of select="a:Richiesta/Dati/Accreditamento/Disconoscimento" />
								<xsl:value-of select="a:Richiesta/Disconoscimento" />
							</p>
						</div-->
					</div>
				</div>

			</div>
		</body>
		</html>	
	</xsl:template>
</xsl:stylesheet>