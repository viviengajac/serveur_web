<?php
include 'FctCommunes.php';
	try
	{
		$nom_dir_base='d:/BLOBS/AccesBdPm/';
		$ab=new AccesBd();
		$ab->Init();
		/*
		$params=$ab->RecupererParams();
		echo $params;
		echo "<br>";
		$tab_params=preg_split('/\//',$params);   // preg_split('#/#',$params);
		print_r($tab_params);
		*/
		$nom_bd=$ab->RecupererNomBd();
		$sql = "select TABLE_NAME from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA='".$nom_bd."' and COLUMN_NAME='doc_fs' and table_schema='".$nom_bd."'  order by 1";
		$tab=$ab->LireListe($sql);
		$nb_tab=count($tab);
//echo 'nb_tab='.$nb_tab;
		for($i=0;$i<$nb_tab;$i++)
		{
			$nom_tab=$tab[$i];
			$nom_dir=$nom_dir_base.$nom_tab;
//echo "nom_dir=".$nom_dir;
			if (is_dir($nom_dir))
			{
//echo "test dir passé";
				$l=strlen($nom_tab)+1;
				if ($dh = opendir($nom_dir))
				{
//echo 'dir ouverte';
					$nb_fic=0;
					while (($nom_fic = readdir($dh)) !== false)
					{
						if($nom_fic!="." && $nom_fic != "..")
						{
							$tab_fic[$nb_fic]=$nom_fic;
							$nb_fic++;
						}
					}
					closedir($dh);
//echo 'nb_fic='.$nb_fic.'<br>';
					for($j=0;$j<$nb_fic;$j++)
					{
						$nom_fic=$tab_fic[$j];
						$pos_point=strpos($nom_fic,'.');
						$id=substr($nom_fic,$l,$pos_point-$l);
//echo "nom_fic=".$nom_fic.", id=".$id."<br>";
						$sql="select count(*) from ".$nom_tab." where id_".$nom_tab."=".$id;
						$nb=$ab->PreparerUneValeur($sql);
						if($nb==0)
						{
Tracer('unlink '.$nom_fic);
//							unlink($nom_fic);
						}
					}
				}
			}
		}
		echo "fini";
	}
//Tracer("pdo.LireUneTable: 6");
	catch(Exception $e)
	{
		TracerErreur("Erreur: LireDir($nom_dir):".$e->getMessage()."\r\n\r".$e->getTraceAsString());
	}

?>