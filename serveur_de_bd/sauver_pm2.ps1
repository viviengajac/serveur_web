# $aujourdhui=$(Get-Date -Format "yyyMMdd")
# $nom_fic="d:/pg_visual_studio/www/AccesBdPm/gestion_pm_"+$aujourdhui+".sql"
# d:/wamp/bin/mysql/mysql5.7.24/bin/mysqldump --user=root gestion_pm > $nom_fic
$nom_fic="d:/pg_visual_studio/www/AccesBdPm/gestion_pm2_"+$(Get-Date -Format "yyyMMdd")+".sql"
d:/wamp/bin/mysql/mysql5.7.24/bin/mysqldump --user=root gestion_pm2 > $nom_fic
