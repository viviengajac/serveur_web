select p.nom_prs,p.prenom_prs,l.nom_loge
from prs p
inner join loge_prs lp on p.id_prs=lp.id_prs
inner join loge l on lp.id_loge=l.id_loge
where not exists (select id_prs_trv from prs_trv pt inner join loge_tenue lt on pt.id_loge_tenue=lt.id_loge_tenue where pt.id_prs=lp.id_prs and lt.id_loge=lp.id_loge union select id_prs_deg from prs_deg pt inner join loge_tenue lt2 on pt.id_loge_tenue=lt2.id_loge_tenue where pt.id_prs=lp.id_prs and lt2.id_loge=lp.id_loge)
order by 1,2,3