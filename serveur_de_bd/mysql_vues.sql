-- drop view v_loge_tenue;
delimiter //
create view v_loge_tenue as
	select lt.id_loge_tenue,l.id_loge,l.nom_loge,lt.date_tenue,c.id_cerem,c.nom_cerem,tt.id_type_tenue,tt.nom_type_tenue,lt.lib_tenue,tl.id_type_loge,tl.nom_type_loge
	from loge_tenue lt
	inner join loge l on lt.id_loge=l.id_loge
	left outer join cerem c on lt.id_cerem=c.id_cerem
	inner join type_tenue tt on lt.id_type_tenue=tt.id_type_tenue
	inner join type_loge tl on l.id_type_loge=tl.id_type_loge;
 //
delimiter ;

-- drop view v_prs_trv;
delimiter //
create view v_prs_trv as
	select pt.id_prs_trv,p.id_prs,p.nom_prs,p.prenom_prs,lt.id_loge_tenue,lt.id_loge,lt.nom_loge,lt.date_tenue,lt.id_cerem,lt.nom_cerem,lt.id_type_tenue,lt.nom_type_tenue,lt.lib_tenue,lt.id_type_loge,lt.nom_type_loge
	from prs_trv pt
	inner join prs p on pt.id_prs=p.id_prs
	inner join v_loge_tenue lt on pt.id_loge_tenue=lt.id_loge_tenue
 //
delimiter ;

-- drop view v_prs_deg;
delimiter //
create view v_prs_deg as
	select pt.id_prs_deg,p.id_prs,p.nom_prs,p.prenom_prs,lt.id_loge_tenue,lt.id_loge,lt.nom_loge,lt.date_tenue,lt.id_cerem,lt.nom_cerem,lt.id_type_tenue,lt.nom_type_tenue,lt.lib_tenue,lt.id_type_loge,lt.nom_type_loge
	from prs_deg pt
	inner join prs p on pt.id_prs=p.id_prs
	inner join v_loge_tenue lt on pt.id_loge_tenue=lt.id_loge_tenue
 //
delimiter ;
