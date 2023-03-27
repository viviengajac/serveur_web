<?php
//Tracer("BBB");
	if(isset($_GET['nom_dir']))
	{
		$nom_dir=$_GET['nom_dir'];
		try
		{
//Tracer("BBB LireDir".$nom_dir);
			if (is_dir($nom_dir))
			{
				if ($dh = opendir($nom_dir))
				{
					echo "[";
					$debut=1;
					while (($file = readdir($dh)) !== false)
					{
						if($file!="." && $file != "..")
						{
							if($debut==0)
								echo ",";
							echo $file.":";
							if(is_dir($nom_dir."/".$file))
							{
								echo "D";
							}
							else
							{
								echo "F";
							}
							$debut=0;
						}
					}
					closedir($dh);
					echo "]";
				}
			}
		}
		catch(Exception $e)
		{
			TracerErreur("Erreur: LireDir($nom_dir):".$e->getMessage()."\r\n\r".$e->getTraceAsString());
		}
	}
?>