select p.nom_prs,p.prenom_prs,l.nom_loge,d.nom_deg,p.ad_elec
from prs p
inner join loge l on p.id_loge=l.id_loge
inner join deg d on p.id_deg_bl=d.id_deg
inner join etat_prs e on p.id_etat_prs=e.id_etat_prs
where e.actif=1
order by 3,1,2