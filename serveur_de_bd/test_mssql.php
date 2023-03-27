<?php
include 'FctCommunes.php';
//Tracer("début");
	$sql="select * from prs";
//Tracer("sql=".$sql);
//print "sql=($sql)";
	try
	{
		$sql="select * from prs";
		$fic_strcnx=fopen('strcnx_php.txt','r');
		$strcnx=fgets($fic_strcnx);
		fclose($fic_strcnx);
		$params=preg_split('/\|/',$strcnx);
		$cnxstr=$params[0];
		$uid=$params[1];
		$pwd=$params[2];
		$bd=$params[3];
		$type_cnx=$params[4];
		$type_bd_sql=$params[5];
		$srv=$params[6];
		sqlsrv_configure("WarningsReturnAsErrors", 0);
		$connectionInfo = array( "Database"=>$bd, "UID"=>$uid, "PWD"=>$pwd);
//Tracer("LireUneTable: srv=".$this->m_srv.", bd=".$this->m_bd.", uid=".$this->m_uid.", pwd=".$this->m_pwd);
		$cnx = sqlsrv_connect($srv, $connectionInfo);
		if($cnx)
		{
			$params = array();
//							$options =  array( "Scrollable" => SQLSRV_CURSOR_KEYSET );
			$options =  array( "Scrollable" => SQLSRV_CURSOR_STATIC );
			$results = sqlsrv_query($cnx,$sql,$params,$options);
Tracer("LireUneTableMSSQL(".$sql.")");
//							$results = sqlsrv_query($cnx,$sql);
//							$results = sqlsrv_prepare($cnx,$sql,$params,$options);
			if($results === false)
			{
				$msg="Erreur d'exécution du SQL pour sql=(".$sql.")";
				TracerErreur($msg);
				$errs=sqlsrv_errors();
				foreach($errs as $err)
				{
					$msg=$err['message']."/".$err['code'];
					TracerErreur($msg);
				}
			}
			else
			{
				$nb_col=sqlsrv_num_fields($results);
				$metadata=sqlsrv_field_metadata($results);
Tracer("MSSQL: nb_col=$nb_col");
				for($i=0;$i<$nb_col;$i++)
				{
					$nom_col=$metadata[$i]["Name"];
					$max_length=$metadata[$i]["Size"];
					$type_col=$metadata[$i]["Type"];
Tracer("nom_col=".$nom_col.", type_col=".$type_col);
				}
				$nb_lig=sqlsrv_num_rows($results);
Tracer("MSSQL: nb_lig=($nb_lig)");
				for($num_lig=0;$num_lig<$nb_lig;$num_lig++)
				{
					$row=sqlsrv_fetch($results,SQLSRV_SCROLL_NEXT);
//Tracer("apres sql_fetch");
					if($row===false ||$num_lig>=$nb_lig)
						$fini=1;
					$nb_cel=0;
//					$this->WriteStartArray();
					$debut=1;
					for($j=0;$j<$nb_col;$j++)
					{
						$val_col=$row[$metadata[$j]["Name"]];
						$type_col=$metadata[$j]["Type"];
Tracer("j=".$j.", metadata=".$metadata[$j].", val_col=".$val_col.", type_col=".$type_col);
					}
				}
				sqlsrv_free_stmt($results);
			}
		}
		else
		{
			$msg="Erreur de connexion au serveur SQL";
			TracerErreur($msg);
		}
	}
	catch(Exception $e)
	{
		Tracer("Erreur: LireUneTable($sql):".$e->getMessage());
//			print "Erreur: LireUneTable($sql):".$e->getMessage();
	}
?>