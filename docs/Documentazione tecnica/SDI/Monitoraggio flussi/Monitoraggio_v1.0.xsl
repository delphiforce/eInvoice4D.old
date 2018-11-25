<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:a="http://www.fatturapa.gov.it/sdi/monitoraggio/v1.0">
	<xsl:output version="4.0" method="html" indent="no"
		encoding="UTF-8" doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/html4/loose.dtd" />
	<xsl:param name="SV_OutputFormat" select="'HTML'" />
	<xsl:variable name="XML" select="/" />

	<xsl:template name="FormatDate">
		<xsl:param name="DateTime" />

		<xsl:variable name="year" select="substring($DateTime,1,4)" />
		<xsl:variable name="month" select="substring($DateTime,6,2)" />
		<xsl:variable name="day" select="substring($DateTime,9,2)" />

		<xsl:value-of select="$day" />
		<xsl:value-of select="' '" />
		<xsl:choose>
			<xsl:when test="$month = '1' or $month = '01'">
				Gennaio
			</xsl:when>
			<xsl:when test="$month = '2' or $month = '02'">
				Febbraio
			</xsl:when>
			<xsl:when test="$month = '3' or $month = '03'">
				Marzo
			</xsl:when>
			<xsl:when test="$month = '4' or $month = '04'">
				Aprile
			</xsl:when>
			<xsl:when test="$month = '5' or $month = '05'">
				Maggio
			</xsl:when>
			<xsl:when test="$month = '6' or $month = '06'">
				Giugno
			</xsl:when>
			<xsl:when test="$month = '7' or $month = '07'">
				Luglio
			</xsl:when>
			<xsl:when test="$month = '8' or $month = '08'">
				Agosto
			</xsl:when>
			<xsl:when test="$month = '9' or $month = '09'">
				Settembre
			</xsl:when>
			<xsl:when test="$month = '10'">
				Ottobre
			</xsl:when>
			<xsl:when test="$month = '11'">
				Novembre
			</xsl:when>
			<xsl:when test="$month = '12'">
				Dicembre
			</xsl:when>
			<xsl:otherwise>
				Mese non riconosciuto
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="' '" />
		<xsl:value-of select="$year" />

		<xsl:variable name="time" select="substring($DateTime,12)" />
		<xsl:if test="$time != ''">
			<xsl:variable name="hh" select="substring($time,1,2)" />
			<xsl:variable name="mm" select="substring($time,4,2)" />
			<xsl:variable name="ss" select="substring($time,7,2)" />

			<xsl:value-of select="' '" />
			<xsl:value-of select="$hh" />
			<xsl:value-of select="':'" />
			<xsl:value-of select="$mm" />
			<xsl:value-of select="':'" />
			<xsl:value-of select="$ss" />
		</xsl:if>
	</xsl:template>

	<xsl:template name="StatoHr">
		<xsl:param name="ST" />

		<xsl:choose>
			<xsl:when test="$ST='SF00'">
				FILE SCARTATO
			</xsl:when>
			<xsl:when test="$ST='SF01'">
				DA INOLTRARE
			</xsl:when>
			<xsl:when test="$ST='SF02'">
				INOLTRATA
			</xsl:when>
			<xsl:when test="$ST='SF03'">
				ACCETTATA
			</xsl:when>
			<xsl:when test="$ST='SF04'">
				RIFIUTATA
			</xsl:when>
			<xsl:when test="$ST='SF05'">
				NON RECAPITABILE
			</xsl:when>
			<xsl:otherwise>
				<span>(VALORE NON ATTESO)</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="ElencoFlussi">
		<xsl:param name="Elenco" />
		<table style="width:100%">
			<tr>
				<th>Fattura e Nome file</th>
				<th>Cedente Prestatore</th>
				<th>Emittente</th>
				<th>Cessionario Committente</th>
				<th>Data Invio</th>
				<th>IdSdi</th>
				<th>Stato</th>
			</tr>

			<xsl:for-each select="$Elenco/Flusso">

				<tr>
					<td>
						Fattura n.
						<xsl:if test="NumeroFattura=''">
							(non disponibile)
						</xsl:if>
						<xsl:if test="NumeroFattura!=''">
							<xsl:value-of select="NumeroFattura" />
						</xsl:if>

						del
						<xsl:if test="DataFattura=''">
							(non disponibile)
						</xsl:if>
						<xsl:if test="DataFattura!=''">
							<xsl:call-template name="FormatDate">
								<xsl:with-param name="DateTime" select="DataFattura" />
							</xsl:call-template>
						</xsl:if>

						<br />
						<xsl:value-of select="NomeFile" />
					</td>
					<td>
						<xsl:value-of select="IdFiscaleCedente" />
					</td>
					<td>
						<xsl:value-of select="IdFiscaleEmittente" />
					</td>
					<td>
						<xsl:value-of select="IdFiscaleCessionario" />
					</td>
					<td>
						<xsl:call-template name="FormatDate">
							<xsl:with-param name="DateTime" select="DataInvio" />
						</xsl:call-template>
					</td>
					<td>
						<xsl:value-of select="IdSdI" />
					</td>
					<td>
						<xsl:call-template name="StatoHr">
							<xsl:with-param name="ST" select="Stato" />
						</xsl:call-template>
					</td>
				</tr>

			</xsl:for-each>

		</table>
	</xsl:template>

	<xsl:template match="/">
		<html>
			<head>
				<meta http-equiv="X-UA-Compatible" content="IE=edge" />
				<style type="text/css">
					#report-container { width: 100%; position:
					relative; font-family: sans-serif; }

					#report { margin-left: auto;
					margin-right: auto; max-width: 1280px; min-width: 930px; padding:
					0; }
					#report h1 { padding: 20px 0 0 0; margin: 0; font-size: 30px; }
					#report h2 { padding: 20px 0 0 0; margin: 0; font-size: 20px;
					border-bottom: 2px solid #333333; }
					#report h3 { padding: 20px 0 0
					0; margin: 0; font-size: 17px; }
					#report h4 { padding: 20px 0 0 0;
					margin: 0; font-size: 15px; }
					#report h5 { padding: 15px 0 0 0;
					margin: 0; font-size: 14px; font-style: italic; }
					#report ul {
					list-style-type: none; margin: 0 !important; padding: 1em 0 1em 2em
					!important; }
					#report ul li {}
					#report ul li span { font-weight:
					bold; }
					#report div { padding: 0; margin: 0; }

					#report div.page {
					background: #fff url("http://www.fatturapa.gov.it/img/sdi.png")
					right bottom no-repeat !important;
					position: relative;

					margin: 20px 0
					50px 0;
					padding: 60px;

					background: -moz-linear-gradient(0% 0 360deg,
					#FFFFFF, #F2F2F2 20%, #FFFFFF)
					repeat scroll 0 0 transparent;
					border: 1px solid #CCCCCC;
					-webkitbox-shadow: 0 0 10px rgba(0, 0, 0,
					0.3);
					-mozbox-shadow: 0
					0 10px rgba(0, 0, 0, 0.3);
					box-shadow: 0 0
					10px rgba(0, 0, 0, 0.3);
					}

					#report div.header { padding: 50px 0 0 0;
					margin: 0; font-size: 11px;
					text-align: center; color: #777777; }
					#report div.footer { padding:
					50px 0 0 0; margin: 0; font-size:
					11px; text-align: center; color:
					#777777; }
					#report-container
					.versione { font-size: 11px;
					float:right; color: #777777; }

					#report
					table { font-size: .9em; margin-top: 1em; border-collapse:
					collapse; border: 1px solid black; }
					#report table caption { color:
					black; padding: .5em 0; font-weight: bold; }
					#report table th {
					border: 1px solid black; background-color: #f0f0f0; padding: .2em
					.5em; }
					#report table td { border: 1px solid black; padding: .2em
					.5em; }
					#report table td:first-child { text-align: center;
					font-weight: bold; }
				</style>
			</head>
			<body>

				<div id="report-container">
					<div id="report">
						<div class="page">

							<h1>Report monitoraggio flussi</h1>

							<div id="Riepilogo">
								<ul>
									<li>
										Soggetto:
										<span>
											<xsl:value-of select="a:MonitoraggioFlussi/Riepilogo/PNF" />
										</span>
									</li>

									<li>
										Data inizio:
										<span>
											<xsl:call-template name="FormatDate">
												<xsl:with-param name="DateTime"
													select="a:MonitoraggioFlussi/Riepilogo/DataInizio" />
											</xsl:call-template>
										</span>
									</li>

									<li>
										Data fine:
										<span>
											<xsl:call-template name="FormatDate">
												<xsl:with-param name="DateTime"
													select="a:MonitoraggioFlussi/Riepilogo/DataFine" />
											</xsl:call-template>
										</span>
									</li>

									<xsl:if test="a:MonitoraggioFlussi/Riepilogo/IdSdI!=''">
										<li>
											Identificativo SdI:
											<span>
												<xsl:value-of select="a:MonitoraggioFlussi/Riepilogo/IdSdI" />
											</span>
										</li>
									</xsl:if>

									<xsl:if
										test="a:MonitoraggioFlussi/Riepilogo/CodiceFiscaleCedente!=''">
										<li>
											Codice Fiscale Cedente:
											<span>
												<xsl:value-of
													select="a:MonitoraggioFlussi/Riepilogo/CodiceFiscaleCedente" />
											</span>
										</li>
									</xsl:if>

									<xsl:if
										test="a:MonitoraggioFlussi/Riepilogo/CodiceFiscaleEmittente!=''">
										<li>
											Codice Fiscale Emittente:
											<span>
												<xsl:value-of
													select="a:MonitoraggioFlussi/Riepilogo/CodiceFiscaleEmittente" />
											</span>
										</li>
									</xsl:if>

									<xsl:if
										test="a:MonitoraggioFlussi/Riepilogo/CodiceFiscaleCessionario!=''">
										<li>
											Codice Fiscale Cessionario:
											<span>
												<xsl:value-of
													select="a:MonitoraggioFlussi/Riepilogo/CodiceFiscaleCessionario" />
											</span>
										</li>
									</xsl:if>

									<xsl:if test="a:MonitoraggioFlussi/Riepilogo/Stato!=''">
										<li>
											Stato:
											<span>
												<xsl:call-template name="StatoHr">
													<xsl:with-param name="ST" select="a:MonitoraggioFlussi/Riepilogo/Stato" />
												</xsl:call-template>
											</span>
										</li>
									</xsl:if>
								</ul>
							</div>


							<h2>Fatture Emesse</h2>
							<xsl:if test="a:MonitoraggioFlussi/FattureEmesse!=''">
								<xsl:call-template name="ElencoFlussi">
									<xsl:with-param name="Elenco"
										select="a:MonitoraggioFlussi/FattureEmesse" />
								</xsl:call-template>
							</xsl:if>
							<xsl:if test="a:MonitoraggioFlussi/FattureEmesse=''">
								Nessuna
							</xsl:if>

						</div>

						<div class="page">
							<h2>Fatture Trasmesse</h2>
							<xsl:if test="a:MonitoraggioFlussi/FattureTrasmesse!=''">
								<xsl:call-template name="ElencoFlussi">
									<xsl:with-param name="Elenco"
										select="a:MonitoraggioFlussi/FattureTrasmesse" />
								</xsl:call-template>
							</xsl:if>
							<xsl:if test="a:MonitoraggioFlussi/FattureTrasmesse=''">
								Nessuna
							</xsl:if>
						</div>

						<div class="page">
							<h2>Fatture Ricevute</h2>
							<xsl:if test="a:MonitoraggioFlussi/FattureRicevute!=''">
								<xsl:call-template name="ElencoFlussi">
									<xsl:with-param name="Elenco"
										select="a:MonitoraggioFlussi/FattureRicevute" />
								</xsl:call-template>
							</xsl:if>
							<xsl:if test="a:MonitoraggioFlussi/FattureRicevute=''">
								Nessuna
							</xsl:if>

						</div>
					</div>
				</div>

			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>