<?php
include 'FctCommunes.php';
	try
	{
//			$fp=fopen("D:\\temp\\azer.txt","a+");
//			fputs($fp,date("Ymd:H:i:s")."\tLireValeur($sql)\r\n");
//			fclose($fp);
		$ab=new AccesBd();
		$ab->Init();
		$ab->RecupererParams();
	}
	catch(Exception $e)
	{
		print "Erreur: RecupererParams:".$e->getMessage();
	}
?>