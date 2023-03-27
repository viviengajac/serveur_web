-- drop procedure AZceremMaj;
delimiter //
create procedure AZceremMaj (p_etat char,p_id_cerem int,p_nom_cerem varchar(50),p_lib_cerem varchar(80))
begin
	if (p_etat ='U') then
-- select current_date() into v_date_debog;
-- insert into debog(date_msg,msg) values (v_date_debog,concat('AZloge__tenueMaj: lib_tenue=',p_lib_tenue));
		update cerem set nom_cerem=p_nom_cerem,lib_cerem=p_lib_cerem where id_cerem=p_id_cerem;
	elseif (p_etat = 'I') then
		insert into cerem (nom_cerem,lib_cerem) values (p_nom_cerem,p_lib_cerem);
	elseif (p_etat = 'D') then
		delete from cerem where id_cerem=p_id_cerem;
	end if;
end; //
delimiter ;

-- drop procedure AZceremSelect;
delimiter //
create procedure AZceremSelect ()
begin
	select '' as etat,id_cerem,nom_cerem,lib_cerem from cerem order by nom_cerem;
end; //
delimiter ;
--------------------------
-- drop procedure AZdegMaj;
delimiter //
create procedure AZdegMaj (p_etat char,p_id_deg int,p_code_deg varchar(5),p_nom_deg varchar(50),p_lib_deg varchar(80),p_num_deg int,p_avancement bit)
begin
	if (p_etat ='U') then
-- select current_date() into v_date_debog;
-- insert into debog(date_msg,msg) values (v_date_debog,concat('AZloge__tenueMaj: lib_tenue=',p_lib_tenue));
		update deg set nom_deg=p_nom_deg,lib_deg=p_lib_deg,code_deg=p_code_deg,num_deg=p_num_deg,avancement=p_avancement where id_deg=p_id_deg;
	elseif (p_etat = 'I') then
		insert into deg (nom_deg,lib_deg,code_deg,num_deg,avancement) values (p_nom_deg,p_lib_deg,p_code_deg,p_num_deg,p_avancement);
	elseif (p_etat = 'D') then
		delete from deg where id_deg=p_id_deg;
	end if;
end; //
delimiter ;

-- drop procedure AZdegSelect;
delimiter //
create procedure AZdegSelect ()
begin
	select '' as etat,id_deg,nom_deg,lib_deg,code_deg,num_deg,avancement from deg order by num_deg;
end; //
delimiter ;
----------------------------
-- drop procedure AZetat_prsMaj;
delimiter //
create procedure AZetat_prsMaj (p_etat char,p_id_etat_prs int,p_nom_etat_prs varchar(50),p_actif bit)
begin
-- declare v_date_debog datetime;
-- declare v_actif varchar(5);
	if (p_etat ='U') then
-- select current_datetime() into v_date_debog;
-- set v_actif=convert(p_actif,char);
-- insert into debog(date_msg,msg) values (v_date_debog,concat('AZetat_prsMaj: actif=(',v_actif,')'));
--		if(p_actif = B'0') then
--			update etat_prs set nom_etat_prs=p_nom_etat_prs,actif=B'0' where id_etat_prs=p_id_etat_prs;
--		elseif (p_actif = B'1') then
--			update etat_prs set nom_etat_prs=p_nom_etat_prs,actif=B'1' where id_etat_prs=p_id_etat_prs;
--		end if;
		update etat_prs set nom_etat_prs=p_nom_etat_prs,actif=p_actif where id_etat_prs=p_id_etat_prs;
	elseif (p_etat = 'I') then
		insert into etat_prs (nom_etat_prs,actif) values (p_nom_etat_prs,p_actif);
	elseif (p_etat = 'D') then
		delete from etat_prs where id_etat_prs=p_id_etat_prs;
	end if;
end; //
delimiter ;

-- drop procedure AZetat_prsSelect;
delimiter //
create procedure AZetat_prsSelect ()
begin
	select '' as etat,id_etat_prs,nom_etat_prs,actif from etat_prs order by nom_etat_prs;
end; //
delimiter ;
-----------------------------------
-- drop procedure AZloge__liste_tenues;
delimiter //
CREATE procedure AZloge__liste_tenues ()
begin
	select t.id_loge_tenue,concat(fct_rep('tenue_date',t.id_loge_tenue),case IsNull(t.id_cerem) when 0 then concat(' (',c.nom_cerem,')') else '' end) as lib_tenue
	from loge_tenue t
	left outer join cerem c on t.id_cerem=c.id_cerem
	where 1=1
	order by t.date_tenue;
end; //
delimiter ;
-----------------------------------
-- drop procedure AZloge__loge_docMaj;
delimiter //
create procedure AZloge__loge_docMaj (p_etat char,p_id_loge_doc int,p_id_loge int,p_nom_doc nvarchar(30),p_lib_doc nvarchar(80),p_date_doc datetime,p_id_type_doc int,p_id_type_fic int)
begin
	if (p_etat ='U') then
-- select current_date() into v_date_debog;
-- insert into debog(date_msg,msg) values (v_date_debog,concat('AZloge__tenueMaj: lib_tenue=',p_lib_tenue));
		update loge_doc set nom_doc=p_nom_doc,lib_doc=p_lib_doc,date_doc=p_date_doc,id_type_doc=p_id_type_doc,id_type_fic=p_id_type_fic where id_loge_doc=p_id_loge_doc;
	elseif (p_etat = 'I') then
		insert into loge_doc (id_loge,nom_doc,lib_doc,date_doc,id_type_doc,id_type_fic) values (p_id_loge,p_nom_doc,p_lib_doc,p_date_doc,p_id_type_doc,p_id_type_fic);
	elseif (p_etat = 'D') then
		delete from loge_doc where id_loge_doc=p_id_loge_doc;
	end if;
end; //
delimiter ;

-- drop procedure AZloge__loge_docSelect;
delimiter //
create procedure AZloge__loge_docSelect (in p_id_loge int)
begin
	select '' as etat,d.id_loge_doc,d.id_loge,d.id_type_doc,t.nom_type_doc as id_type_docWITH,octet_length(doc_db) as voir_doc_db,d.id_loge_doc as def_doc_db,doc_fs as voir_doc_fs,d.id_loge_doc as def_doc_fs,d.nom_doc,d.lib_doc,d.date_doc,d.id_type_fic,tf.nom_type_fic as id_type_ficWITH
	from loge_doc d
	left outer join type_doc t on d.id_type_doc=t.id_type_doc
	left outer join type_fic tf on d.id_type_fic=tf.id_type_fic
	where d.id_loge=p_id_loge
	order by t.num_doc,d.nom_doc;
end; //
delimiter ;
-------------------------------
-- drop procedure AZloge__logeMaj;
delimiter //
create procedure AZloge__logeMaj (p_etat char,p_id_loge int,p_code_loge varchar(5),p_nom_loge varchar(50),p_id_obed int,p_id_orient int,p_id_type_loge int,p_num_loge int,p_id_rite int,p_id_terr int,p_id_temple int,p_num_rna varchar(15),p_active bit)
begin
	if (p_etat ='U') then
-- select current_date() into v_date_debog;
-- insert into debog(date_msg,msg) values (v_date_debog,concat('AZloge__tenueMaj: lib_tenue=',p_lib_tenue));
		update loge set code_loge=p_code_loge,nom_loge=p_nom_loge,id_orient=p_id_orient,id_obed=p_id_obed,id_type_loge=p_id_type_loge,num_loge=p_num_loge,id_rite=p_id_rite,id_terr=p_id_terr,id_temple=p_id_temple,num_rna=p_num_rna,active=p_active where id_loge=p_id_loge;
	elseif (p_etat = 'I') then
		insert into loge (code_loge,nom_loge,id_orient,id_obed,id_type_loge,num_loge,id_rite,id_terr,id_temple,num_rna,active) values (p_code_loge,p_nom_loge,p_id_orient,p_id_obed,p_id_type_loge,p_num_loge,p_id_rite,p_id_terr,p_id_temple,p_num_rna,p_active);
	elseif (p_etat = 'D') then
		delete from loge where id_loge=p_id_loge;
	end if;
end; //
delimiter ;

-- drop procedure AZloge__logeSelect;
delimiter //
create procedure AZloge__logeSelect (in p_id_loge int)
begin
	select '' as etat,l.id_loge,l.code_loge,l.nom_loge,l.id_obed,o.nom_obed as id_obedWITH,l.id_orient,ot.nom_orient as id_orientWITH,l.id_type_loge,tl.nom_type_loge as id_type_logeWITH,l.num_loge,l.id_rite,r.nom_rite as id_riteWITH,l.id_terr,t.nom_terr as id_terrWITH,l.id_temple,tp.lib_temple as id_templeWITH,num_rna,active
	from loge l
	inner join obed o on l.id_obed=o.id_obed
	inner join orient ot on l.id_orient=ot.id_orient
	inner join type_loge tl on l.id_type_loge=tl.id_type_loge
	left outer join rite r on l.id_rite=r.id_rite
	left outer join terr t on l.id_terr=t.id_terr
	left outer join temple tp on l.id_temple=tp.id_temple
	where id_loge=p_id_loge;
end; //
delimiter ;
-----------------------------
-- drop procedure AZloge__prsMaj;
delimiter //
create procedure AZloge__prsMaj (p_etat char,p_id_loge_prs int,p_id_loge int,p_id_prs int)
begin
--	declare v_date_debog datetime;
	declare v_nb int;
	if (p_etat ='U') then
-- select current_date() into v_date_debog;
-- insert into debog(date_msg,msg) values (v_date_debog,concat('AZloge__tenueMaj: lib_tenue=',p_lib_tenue));
		update loge_prs set id_prs=p_id_prs,id_loge=p_id_loge where id_loge_prs=p_id_loge_prs;
	elseif (p_etat = 'I') then
-- select current_date() into v_date_debog;
		select count(*) into v_nb from prs where id_prs=p_id_prs and id_loge=p_id_loge;
		if(v_nb=0) then
-- insert into debog(date_msg,msg) values (v_date_debog,concat('AZloge__prsMaj: insertion','A'));
			insert into loge_prs (id_loge,id_prs) values (p_id_loge,p_id_prs);
		end if;
	elseif (p_etat = 'D') then
		delete from loge_prs where id_loge_prs=p_id_loge_prs;
	end if;
end; //
delimiter ;

-- drop procedure AZloge__prsSelect;
delimiter //
create procedure AZloge__prsSelect (in p_id_loge int)
begin
	select * from (
	select '' as etat,0 as id_loge_prs,id_loge,id_prs,concat(nom_prs,' ',prenom_prs) as id_prsWITH,nom_deg,ad_elec,concat(v.code_postal,' ',v.nom_ville) as id_villeWITH
		from prs p
		inner join deg on p.id_deg_bl=deg.id_deg
		inner join etat_prs e on p.id_etat_prs=e.id_etat_prs and actif=1
		inner join ville v on p.id_ville=v.id_ville
		where id_loge=p_id_loge
	union
	select '' as etat,pl.id_loge_prs,pl.id_loge,p.id_prs,concat(nom_prs,' ',prenom_prs) as id_prsWITH,case IsNull(deg_av.id_deg) when 1 then deg_bl.nom_deg else deg_av.nom_deg end as nom_deg,ad_elec,concat(v.code_postal,' ',v.nom_ville) as id_villeWITH
		from loge_prs pl
		inner join prs p on pl.id_prs=p.id_prs
		inner join deg deg_bl on p.id_deg_bl=deg_bl.id_deg
		left outer join deg deg_av on p.id_deg_av=deg_av.id_deg
		inner join etat_prs e on p.id_etat_prs=e.id_etat_prs and actif=1
		inner join ville v on p.id_ville=v.id_ville
		where pl.id_loge=p_id_loge
	) a
	order by id_prsWITH;
end; //
delimiter ;
-------------------------------
-- drop procedure AZloge__prs_offSelect;
delimiter //
create procedure AZloge__prs_offSelect (p_id_loge int)
begin
	select '' as etat,po.id_prs_off,po.id_loge,po.id_type_off,tof.nom_type_off as id_type_offWITH,po.id_prs,concat(nom_prs,' ',prenom_prs) as id_prsWITH
	from prs_off po
	inner join type_off tof on po.id_type_off=tof.id_type_off
	inner join prs p on po.id_prs=p.id_prs
	where po.id_loge=p_id_loge and po.id_loge_tenue_fin is null
	order by tof.num_off;
end; //
delimiter ;
--------------------------------
-- drop procedure AZloge__prs_off__ancienSelect;
delimiter //
create procedure AZloge__prs_off__ancienSelect (p_id_loge int)
begin
	select '' as etat,po.id_prs_off as id_prs_off__ancien,po.id_loge,po.id_loge_tenue_deb,fct_rep('tenue_date',po.id_loge_tenue_deb) as id_loge_tenue_debWITH,po.id_loge_tenue_fin,fct_rep('tenue_date',po.id_loge_tenue_fin) as id_loge_tenue_finWITH,po.id_type_off,tof.nom_type_off as id_type_offWITH,po.id_prs,fct_rep('prs',po.id_prs) as id_prsWITH
	from prs_off po
	inner join loge_tenue td on po.id_loge_tenue_deb=td.id_loge_tenue
	inner join type_off tof on po.id_type_off=tof.id_type_off
	where po.id_loge=p_id_loge and po.id_loge_tenue_fin is not null
	order by tof.num_off,td.date_tenue,tof.num_off;
end; //
delimiter ;
--------------------------------
-- drop procedure AZloge__loge_tenueMaj;
delimiter //
create procedure AZloge__loge_tenueMaj (p_etat char,p_id_loge_tenue int,p_id_loge int,p_id_type_tenue int,p_date_tenue date,p_id_cerem int,p_lib_tenue varchar(500))
begin
--	declare v_date_debog datetime default current_date();
	if (p_etat ='U') then
-- select current_date() into v_date_debog;
-- insert into debog(date_msg,msg) values (v_date_debog,concat('AZloge__tenueMaj: lib_tenue=',p_lib_tenue));
		update loge_tenue set id_type_tenue=p_id_type_tenue,date_tenue=p_date_tenue,id_cerem=p_id_cerem,lib_tenue=p_lib_tenue where id_loge_tenue=p_id_loge_tenue;
	elseif (p_etat = 'I') then
		insert into loge_tenue (id_loge,id_type_tenue,date_tenue,id_cerem,lib_tenue) values (p_id_loge,p_id_type_tenue,p_date_tenue,p_id_cerem,p_lib_tenue);
	elseif (p_etat = 'D') then
		delete from loge_tenue where id_loge_tenue=p_id_loge_tenue;
	end if;
end; //
delimiter ;

-- drop procedure AZloge__loge_tenueSelect;
delimiter //
create procedure AZloge__loge_tenueSelect (in p_id_loge int)
begin
	select '' as etat,t.id_loge_tenue,t.id_loge,t.id_type_tenue,tt.nom_type_tenue as id_type_tenueWITH,t.date_tenue,t.id_cerem,c.nom_cerem as id_ceremWITH,t.lib_tenue,fct_tenue_prs(t.id_loge_tenue) as liste_prs,doc_fs as voir_doc_fs,t.id_loge_tenue as def_doc_fs,t.id_type_fic,tf.nom_type_fic as id_type_ficWITH
	from loge_tenue t
	inner join type_tenue tt on t.id_type_tenue=tt.id_type_tenue
	left outer join cerem c on t.id_cerem=c.id_cerem
	left outer join type_fic tf on t.id_type_fic=tf.id_type_fic
	where t.id_loge=p_id_loge
	order by t.date_tenue;
end; //
delimiter ;
-----------------------------
-- drop procedure AZloge__recherche;
delimiter //
create procedure AZloge__recherche (p_id_prs_login int,p_nom_loge varchar(50),p_id_obed int,p_id_terr int,p_id_orient int)
begin
-- select top 200 count(*) over() as nb_lig,l.id_loge,l.nom_loge,l.id_obed,o.nom_obed as id_obedWITH,l.id_orient,orient.nom_orient as id_orientWITH,num_loge as Numéro,l.id_type_loge,tl.lib_type_loge as id_type_logeWITH
	declare v_id_loge_login int;
	declare v_id_deg_login int;
	declare v_num_deg_login int;
	declare v_nivo_lec_login int;
	declare v_id_terr_login int;
	select p.id_loge,id_deg_av,nivo_lec,id_terr into v_id_loge_login,v_id_deg_login,v_nivo_lec_login,v_id_terr_login
		from prs p
		inner join loge l on p.id_loge=l.id_loge
		where id_prs=p_id_prs_login;
	if(v_id_deg_login is null) then
		set v_num_deg_login=1;
	else
		select num_deg into v_num_deg_login from deg where id_deg=v_id_deg_login;
	end if;
	select l.id_loge,l.code_loge as Code,l.nom_loge as Nom,o.nom_obed as Obédience,orient.nom_orient as Orient,l.num_loge as Numéro,tl.lib_type_loge as Type
	 FROM loge l
	 inner join obed o on l.id_obed=o.id_obed
	 inner join orient on l.id_orient=orient.id_orient
	 inner join type_loge tl on l.id_type_loge=tl.id_type_loge
	 inner join deg d on tl.id_deg=d.id_deg
	  where 1=1
	  and (l.nom_loge like p_nom_loge or p_nom_loge is null)
	   and (l.id_obed=p_id_obed or p_id_obed is null)
	    and (l.id_terr=p_id_terr or p_id_terr is null)
	    and (l.id_orient=p_id_orient or p_id_orient is null)
--		and (p.id_loge=l.id_loge or l.id_loge in (select id_loge from loge_prs where id_prs=p_id_prs_login))
		and (d.num_deg<=v_num_deg_login)
		and ((v_nivo_lec_login=2 and (l.id_loge=v_id_loge_login or l.id_loge in (select id_loge from loge_prs where id_prs=p_id_prs_login))) or (v_nivo_lec_login=3 and l.id_terr=v_id_terr_login) or v_nivo_lec_login=4)
	    ORDER BY l.nom_loge;
end; //
delimiter ;
-------------------------
-- drop procedure AZobedMaj;
delimiter //
create procedure AZobedMaj (p_etat char,p_id_obed int,p_nom_obed varchar(50),p_lib_obed varchar(80))
begin
	if (p_etat ='U') then
		update obed set nom_obed=p_nom_obed,lib_obed=p_lib_obed where id_obed=p_id_obed;
	elseif (p_etat = 'I') then
		insert into obed (nom_obed,lib_obed) values (p_nom_obed,p_lib_obed);
	elseif (p_etat = 'D') then
		delete from obed where id_obed=p_id_obed;
	end if;
end; //
delimiter ;

-- drop procedure AZobedSelect;
delimiter //
create procedure AZobedSelect ()
begin
	select '' as etat,id_obed,nom_obed,lib_obed from obed order by nom_obed;
end; //
delimiter ;
-------------------------
-- drop procedure AZorientMaj;
delimiter //
create procedure AZorientMaj (p_etat char,p_id_orient int,p_nom_orient varchar(50))
begin
	if (p_etat ='U') then
		update orient set nom_orient=p_nom_orient where id_orient=p_id_orient;
	elseif (p_etat = 'I') then
		insert into orient (nom_orient) values (p_nom_orient);
	elseif (p_etat = 'D') then
		delete from orient where id_orient=p_id_orient;
	end if;
end; //
delimiter ;

-- drop procedure AZorientSelect;
delimiter //
create procedure AZorientSelect ()
begin
	select '' as etat,id_orient,nom_orient from orient order by nom_orient;
end; //
delimiter ;
-------------------------------
-- drop procedure AZprs__liste_tenues;
delimiter //
CREATE procedure AZprs__liste_tenues (p_id_loge int, p_id_loge_tenue_date_min int)
begin
	declare v_date_min datetime;
	if(p_id_loge_tenue_date_min>0)then
		select date_tenue into v_date_min from loge_tenue where id_loge_tenue=p_id_loge_tenue_date_min;
		if(p_id_loge>0) then
			select t.id_loge_tenue,concat(fct_rep('tenue_date',t.id_loge_tenue),case IsNull(t.id_cerem) when 0 then concat(' (',c.nom_cerem,')') else '' end) as lib_tenue
			from loge_tenue t
			left outer join cerem c on t.id_cerem=c.id_cerem
			where 1=1
			and t.id_loge=p_id_loge
			and t.date_tenue>v_date_min
			order by t.date_tenue;
		else
			select t.id_loge_tenue,concat(fct_rep('tenue_date',t.id_loge_tenue),case IsNull(t.id_cerem) when 0 then concat(' (',c.nom_cerem,')') else '' end) as lib_tenue
			from loge_tenue t
			left outer join cerem c on t.id_cerem=c.id_cerem
			where 1=1
			and t.date_tenue>v_date_min
			order by t.date_tenue;
		end if;
	else
		if(p_id_loge>0) then
			select t.id_loge_tenue,concat(fct_rep('tenue_date',t.id_loge_tenue),case IsNull(t.id_cerem) when 0 then concat(' (',c.nom_cerem,')') else '' end) as lib_tenue
			from loge_tenue t
			left outer join cerem c on t.id_cerem=c.id_cerem
			where 1=1
			and t.id_loge=p_id_loge
			order by t.date_tenue;
		else
			select t.id_loge_tenue,concat(fct_rep('tenue_date',t.id_loge_tenue),case IsNull(t.id_cerem) when 0 then concat(' (',c.nom_cerem,')') else '' end) as lib_tenue
			from loge_tenue t
			left outer join cerem c on t.id_cerem=c.id_cerem
			where 1=1
			order by t.date_tenue;
		end if;
	end if;
end; //
delimiter ;
-----------------------------------
-- drop procedure AZprs__prs_docMaj;
delimiter //
create procedure AZprs__prs_docMaj (p_etat char,p_id_prs_doc int,p_id_prs int,p_nom_doc nvarchar(30),p_lib_doc nvarchar(80),p_date_doc datetime,p_id_type_doc int,p_id_type_fic int)
begin
	if (p_etat ='U') then
-- select current_date() into v_date_debog;
-- insert into debog(date_msg,msg) values (v_date_debog,concat('AZloge__tenueMaj: lib_tenue=',p_lib_tenue));
		update prs_doc set nom_doc=p_nom_doc,lib_doc=p_lib_doc,date_doc=p_date_doc,id_type_doc=p_id_type_doc,id_type_fic=p_id_type_fic where id_prs_doc=p_id_prs_doc;
	elseif (p_etat = 'I') then
		insert into prs_doc (id_prs,nom_doc,lib_doc,date_doc,id_type_doc,id_type_fic) values (p_id_prs,p_nom_doc,p_lib_doc,p_date_doc,p_id_type_doc,p_id_type_fic);
	elseif (p_etat = 'D') then
		delete from prs_doc where id_prs_doc=p_id_prs_doc;
	end if;
end; //
delimiter ;

-- drop procedure AZprs__prs_docSelect;
delimiter //
create procedure AZprs__prs_docSelect (in p_id_prs int)
begin
	select '' as etat,d.id_prs_doc,d.id_prs,d.id_type_doc,t.nom_type_doc as id_type_docWITH,octet_length(doc_db) as voir_doc_db,d.id_prs_doc as def_doc_db,doc_fs as voir_doc_fs,d.id_prs_doc as def_doc_fs,d.id_type_fic,tf.nom_type_fic as id_type_ficWITH,d.nom_doc,d.lib_doc,d.date_doc
	from prs_doc d
	left outer join type_doc t on d.id_type_doc=t.id_type_doc
	left outer join type_fic tf on d.id_type_fic=tf.id_type_fic
	where d.id_prs=p_id_prs
	order by t.num_doc,d.nom_doc;
end; //
delimiter ;
----------------------
-- drop procedure AZprs__prs_offMaj;
delimiter //
create procedure AZprs__prs_offMaj (p_etat char,p_id_prs_off int,p_id_prs int,p_id_loge int,p_id_type_off int,p_id_loge_tenue_deb int,p_id_loge_tenue_fin int)
begin
	if (p_etat ='U') then
		update prs_off set id_prs=p_id_prs,id_loge=p_id_loge,id_type_off=p_id_type_off,id_loge_tenue_deb=p_id_loge_tenue_deb,id_loge_tenue_fin=p_id_loge_tenue_fin where id_prs_off=p_id_prs_off;
	elseif (p_etat = 'I') then
		insert into prs_off (id_prs,id_loge,id_type_off,id_loge_tenue_deb,id_loge_tenue_fin) values (p_id_prs,p_id_loge,p_id_type_off,p_id_loge_tenue_deb,p_id_loge_tenue_fin);
	elseif (p_etat = 'D') then
		delete from prs_off where id_prs_off=p_id_prs_off;
	end if;
end; //
delimiter ;

-- drop procedure AZprs__prs_offSelect;
delimiter //
create procedure AZprs__prs_offSelect (in p_id_prs int)
begin
	select '' as etat,p.id_prs_off,p.id_prs,p.id_loge,l.nom_loge as id_logeWITH,p.id_type_off,o.nom_type_off as id_type_offWITH,
	p.id_loge_tenue_deb,fct_rep('tenue_date',p.id_loge_tenue_deb) as id_loge_tenue_debWITH,
	p.id_loge_tenue_fin,fct_rep('tenue_date',p.id_loge_tenue_fin) as id_loge_tenue_finWITH
	from prs_off p
	inner join loge l on p.id_loge=l.id_loge
	inner join type_off o on p.id_type_off=o.id_type_off
	inner join loge_tenue td on p.id_loge_tenue_deb=td.id_loge_tenue
	where p.id_prs=p_id_prs
	order by l.nom_loge,td.date_tenue,o.num_off;
end; //
delimiter ;
---------------------------
-- drop procedure AZprs__prsMaj;
delimiter //
create procedure AZprs__prsMaj (p_etat char,p_id_prs int,p_nom_prs varchar(30),p_prenom_prs varchar(20),p_id_loge int,p_ad1 varchar(80),p_ad2 varchar(80),p_id_ville int,p_ad_elec varchar(80),p_tel1 varchar(20),p_tel2 varchar(20),p_id_etat_prs int,p_lieu_comp varchar(80),p_nom_comp varchar(80),p_info_prs varchar(600),p_id_deg_bl int,p_id_deg_av int,p_date_naiss datetime,p_lieu_naiss varchar(30),p_nom_naiss varchar(30),p_genre int,p_sign_charte bit,p_conserv_20_ans bit)
begin
	if (p_etat ='U') then
		update prs set nom_prs=p_nom_prs,prenom_prs=p_prenom_prs,id_loge=p_id_loge,ad1=p_ad1,ad2=p_ad2,id_ville=p_id_ville,ad_elec=p_ad_elec,tel1=p_tel1,tel2=p_tel2,id_etat_prs=p_id_etat_prs,lieu_comp=p_lieu_comp,nom_comp=p_nom_comp,info_prs=p_info_prs,id_deg_bl=p_id_deg_bl,id_deg_av=p_id_deg_av,date_naiss=p_date_naiss,lieu_naiss=p_lieu_naiss,nom_naiss=p_nom_naiss,genre=p_genre,sign_charte=p_sign_charte,conserv_20_ans=p_conserv_20_ans where id_prs=p_id_prs;
	elseif (p_etat = 'I') then
		insert into prs (nom_prs,prenom_prs,id_loge,ad1,ad2,id_ville,ad_elec,tel1,tel2,id_etat_prs,lieu_comp,nom_comp,info_prs,id_deg_bl,id_deg_av,date_naiss,lieu_naiss,nom_naiss,genre,sign_charte,conserv_20_ans) values (p_nom_prs,p_prenom_prs,p_id_loge,p_ad1,p_ad2,p_id_ville,p_ad_elec,p_tel1,p_tel2,1,p_lieu_comp,p_nom_comp,p_info_prs,p_id_deg_bl,p_id_deg_av,p_date_naiss,p_lieu_naiss,p_nom_naiss,p_genre,p_sign_charte,p_conserv_20_ans);
	elseif (p_etat = 'D') then
		delete from prs where id_prs=p_id_prs;
	end if;
end; //
delimiter ;

-- drop procedure AZprs__prsSelect;
delimiter //
create procedure AZprs__prsSelect (in p_id_prs int)
begin
	select '' as etat,p.id_prs,p.nom_prs,p.prenom_prs,p.id_loge,l.nom_loge as id_logeWITH,p.ad1,p.ad2,p.id_ville,v.nom_ville as id_villeWITH,p.ad_elec,p.tel1,p.tel2,p.id_etat_prs,e.nom_etat_prs as id_etat_prsWITH,p.lieu_comp,p.nom_comp,p.info_prs,p.id_deg_bl,deg_bl.nom_deg as id_deg_blWITH,p.id_deg_av,deg_av.nom_deg as id_deg_avWITH,p.date_naiss,p.lieu_naiss,p.nom_naiss,e.actif,p.genre,p.sign_charte,p.conserv_20_ans
	from prs p
	inner join loge l on p.id_loge=l.id_loge
	inner join ville v on p.id_ville=v.id_ville
	inner join etat_prs e on p.id_etat_prs=e.id_etat_prs
	inner join deg deg_bl on p.id_deg_bl=deg_bl.id_deg
	left outer join deg deg_av on p.id_deg_av=deg_av.id_deg
 where id_prs=p_id_prs;
 end; //
delimiter ;
------------------------------------
-- drop procedure AZprs__prs_degMaj;
delimiter //
create procedure AZprs__prs_degMaj (p_etat char,p_id_prs_deg int,p_id_prs int,p_id_loge_tenue int)
begin
	if (p_etat ='U' and p_id_loge_tenue is not null) then
		update prs_deg set id_loge_tenue=p_id_loge_tenue where id_prs_deg=p_id_prs_deg;
	elseif (p_etat = 'I') then
		insert into prs_deg (id_prs,id_loge_tenue) values (p_id_prs,p_id_loge_tenue);
	elseif (p_etat = 'D') then
		delete from prs_deg where id_prs_deg=p_id_prs_deg;
	end if;
end; //
delimiter ;

-- drop procedure AZprs__prs_degSelect;
delimiter //
create procedure AZprs__prs_degSelect (in p_id_prs int)
begin
	select '' as etat,pt.id_prs_deg,pt.id_prs,t.id_loge,l.nom_loge as id_logeWITH,t.id_loge_tenue,fct_rep('tenue_date',t.id_loge_tenue) as id_loge_tenueWITH,d.nom_deg,fct_rep('loge_tenue_descr',t.id_loge_tenue) as loge_tenue_descr
	from prs_deg pt
	inner join loge_tenue t on pt.id_loge_tenue=t.id_loge_tenue
	inner join loge l on t.id_loge=l.id_loge
	inner join type_tenue tt on t.id_type_tenue=tt.id_type_tenue
	inner join deg d on tt.id_deg=d.id_deg
	where pt.id_prs=p_id_prs
	order by t.date_tenue;
end; //
delimiter ;
------------------------------------
-- drop procedure AZprs__prs_trvMaj;
delimiter //
create procedure AZprs__prs_trvMaj (p_etat char,p_id_prs_trv int,p_id_prs int,p_id_loge_tenue int,p_nom_trv varchar(100))
begin
	if (p_etat ='U' and p_id_loge_tenue is not null) then
		update prs_trv set id_loge_tenue=p_id_loge_tenue,nom_trv=p_nom_trv where id_prs_trv=p_id_prs_trv;
	elseif (p_etat = 'I') then
		insert into prs_trv (id_prs,id_loge_tenue,nom_trv) values (p_id_prs,p_id_loge_tenue,p_nom_trv);
	elseif (p_etat = 'D') then
		delete from prs_trv where id_prs_trv=p_id_prs_trv;
	end if;
end; //
delimiter ;

-- drop procedure AZprs__prs_trvSelect;
delimiter //
create procedure AZprs__prs_trvSelect (in p_id_prs int)
begin
	select '' as etat,pt.id_prs_trv,pt.id_prs,t.id_loge,l.nom_loge as id_logeWITH,t.id_loge_tenue,fct_rep('tenue_date',t.id_loge_tenue) as id_loge_tenueWITH,fct_rep('loge_tenue_descr',t.id_loge_tenue) as loge_tenue_descr,pt.nom_trv,pt.doc_fs as voir_doc_fs,pt.id_prs_trv as def_doc_fs,pt.id_type_fic,tf.nom_type_fic as id_type_ficWITH,tt.nom_type_tenue
	from prs_trv pt
	inner join loge_tenue t on pt.id_loge_tenue=t.id_loge_tenue
	inner join loge l on t.id_loge=l.id_loge
	inner join type_tenue tt on t.id_type_tenue=tt.id_type_tenue
	left outer join type_fic tf on pt.id_type_fic=tf.id_type_fic
	where pt.id_prs=p_id_prs
	order by t.date_tenue;
end; //
delimiter ;
-------------------------
-- drop procedure AZprs__recherche;
delimiter //
create procedure AZprs__recherche (p_id_prs_login int,p_nom_prs varchar(20),p_prenom_prs varchar(20),p_id_terr int,p_id_loge int,p_id_deg_bl int,p_actif bit)
begin
	declare v_actif_bd bit;
	if(p_actif = 1) then
		set v_actif_bd=1;
	else
		set v_actif_bd=0;
	end if;
-- call ap_debog(concat('AZprs__recherche: p_id_prs_login=',p_id_prs_login));

--	select T.id_prs,T.nom_prs,T.prenom_prs,T.id_loge,l.nom_loge as id_logeWITH,T.id_deg_bl,d.nom_deg as id_deg_blWITH,T.ad_elec,T.id_etat_prs,e.nom_etat_prs as id_etat_prsWITH,e.actif
	select T.id_prs,T.nom_prs,T.prenom_prs,l.nom_loge as id_logeWITH,d.nom_deg as id_deg_blWITH,T.ad_elec,e.nom_etat_prs
		FROM prs T
		inner join loge l on T.id_loge=l.id_loge
		inner join deg d on T.id_deg_bl=d.id_deg
	    inner join etat_prs e on T.id_etat_prs=e.id_etat_prs
		inner join prs pl on pl.id_prs=p_id_prs_login
		inner join loge ll on pl.id_loge=ll.id_loge
		WHERE 1=1
			and (T.nom_prs like p_nom_prs or p_nom_prs is null)
			and (T.prenom_prs like p_prenom_prs or p_prenom_prs is null)
			and (T.id_loge=p_id_loge or p_id_loge is null or T.id_prs in (select id_loge from loge_prs where id_loge=p_id_loge))
			and (l.id_terr=p_id_terr or p_id_terr is null)
			and (T.id_deg_bl=p_id_deg_bl or p_id_deg_bl is null)
			and (T.id_etat_prs in (select id_etat_prs from etat_prs where actif=v_actif_bd) or v_actif_bd=0)
			and ((T.id_prs=pl.id_prs) or (pl.nivo_lec=2 and T.id_loge=pl.id_loge) or (pl.nivo_lec=3 and ll.id_terr=l.id_terr) or pl.nivo_lec=4)
		ORDER BY T.nom_prs,T.prenom_prs;
end; //
delimiter ;
-------------------------
-- drop procedure AZriteMaj;
delimiter //
create procedure AZriteMaj (p_etat char,p_id_rite int,p_nom_rite varchar(50),p_lib_rite varchar(80))
begin
	if (p_etat ='U') then
		update rite set nom_rite=p_nom_rite,lib_rite=p_lib_rite where id_rite=p_id_rite;
	elseif (p_etat = 'I') then
		insert into rite (nom_rite,lib_rite) values (p_nom_rite,p_lib_rite);
	elseif (p_etat = 'D') then
		delete from rite where id_rite=p_id_rite;
	end if;
end; //
delimiter ;

-- drop procedure AZriteSelect;
delimiter //
create procedure AZriteSelect ()
begin
	select '' as etat,id_rite,nom_rite,lib_rite from rite order by nom_rite;
end; //
delimiter ;
-------------------------
-- drop procedure AZtempleMaj;
delimiter //
create procedure AZtempleMaj (p_etat char,p_id_temple int,p_nom_temple varchar(20),p_lib_temple varchar(80),p_adr_temple varchar(80),p_id_ville int)
begin
	if (p_etat ='U') then
		update temple set nom_temple=p_nom_temple,lib_temple=p_lib_temple,adr_temple=p_adr_temple,id_ville=p_id_ville where id_temple=p_id_temple;
	elseif (p_etat = 'I') then
		insert into temple (nom_temple,lib_temple,adr_temple,id_ville) values (p_nom_temple,p_lib_temple,adr_temple,id_ville);
	elseif (p_etat = 'D') then
		delete from temple where id_temple=p_id_temple;
	end if;
end; //
delimiter ;

-- drop procedure AZtempleSelect;
delimiter //
create procedure AZtempleSelect ()
begin
	select '' as etat,t.id_temple,t.nom_temple,t.lib_temple,t.adr_temple,t.id_ville,v.nom_ville as id_villeWITH
		from temple t
		inner join ville v on t.id_ville=v.id_ville
		order by t.nom_temple;
end; //
delimiter ;
-------------------------
-- drop procedure AZterrMaj;
delimiter //
create procedure AZterrMaj (p_etat char,p_id_terr int,p_nom_terr varchar(10),p_lib_terr varchar(30))
begin
	if (p_etat ='U') then
		update terr set nom_terr=p_nom_terr,lib_terr=p_lib_terr where id_terr=p_id_terr;
	elseif (p_etat = 'I') then
		insert into terr (nom_terr,lib_terr) values (p_nom_terr,p_lib_terr);
	elseif (p_etat = 'D') then
		delete from terr where id_terr=p_id_terr;
	end if;
end; //
delimiter ;

-- drop procedure AZterrSelect;
delimiter //
create procedure AZterrSelect ()
begin
	select '' as etat,id_terr,nom_terr,lib_terr from terr order by nom_terr;
end; //
delimiter ;
-------------------------
-- drop procedure AZtype_docMaj;
delimiter //
create procedure AZtype_docMaj (p_etat char,p_id_type_doc int,p_code_type_doc varchar(20),p_nom_type_doc varchar(30),p_lib_type_doc varchar(80),p_num_doc int)
begin
	if (p_etat ='U') then
		update type_doc set code_type_doc=p_code_type_doc,nom_type_doc=p_nom_type_doc,lib_type_doc=p_lib_type_doc,num_doc=p_num_doc where id_type_doc=p_id_type_doc;
	elseif (p_etat = 'I') then
		insert into type_doc (code_type_doc,nom_type_doc,lib_type_doc,num_doc) values (p_code_type_doc,p_nom_type_doc,p_lib_type_doc,p_num_doc);
	elseif (p_etat = 'D') then
		delete from type_doc where id_type_doc=p_id_type_doc;
	end if;
end; //
delimiter ;

-- drop procedure AZtype_docSelect;
delimiter //
create procedure AZtype_docSelect ()
begin
	select '' as etat,id_type_doc,code_type_doc,nom_type_doc,lib_type_doc,num_doc from type_doc order by code_type_doc;
end; //
delimiter ;
-------------------------
-- drop procedure AZtype_ficMaj;
delimiter //
create procedure AZtype_ficMaj (p_etat char,p_id_type_fic int,p_code_type_fic varchar(20),p_nom_type_fic varchar(30),p_lib_type_fic varchar(80))
begin
	if (p_etat ='U') then
		update type_fic set code_type_fic=p_code_type_fic,nom_type_fic=p_nom_type_fic,lib_type_fic=p_lib_type_fic where id_type_fic=p_id_type_fic;
	elseif (p_etat = 'I') then
		insert into type_fic (code_type_fic,nom_type_fic,lib_type_fic) values (p_code_type_fic,p_nom_type_fic,p_lib_type_fic);
	elseif (p_etat = 'D') then
		delete from type_fic where id_type_fic=p_id_type_fic;
	end if;
end; //
delimiter ;

-- drop procedure AZtype_ficSelect;
delimiter //
create procedure AZtype_ficSelect ()
begin
	select '' as etat,id_type_fic,code_type_fic,nom_type_fic,lib_type_fic from type_fic order by code_type_fic;
end; //
delimiter ;
-------------------------
-- drop procedure AZtype_logeMaj;
delimiter //
create procedure AZtype_logeMaj (p_etat char,p_id_type_loge int,p_nom_type_loge varchar(50),p_lib_type_loge varchar(80),p_id_deg int)
begin
	if (p_etat ='U') then
		update type_loge set nom_type_loge=p_nom_type_loge,lib_type_loge=p_lib_type_loge,id_deg=p_id_deg where id_type_loge=p_id_type_loge;
	elseif (p_etat = 'I') then
		insert into type_loge (nom_type_loge,lib_type_loge,id_deg) values (p_nom_type_loge,p_lib_type_loge,p_id_deg);
	elseif (p_etat = 'D') then
		delete from type_loge where id_type_loge=p_id_type_loge;
	end if;
end; //
delimiter ;

-- drop procedure AZtype_logeSelect;
delimiter //
create procedure AZtype_logeSelect ()
begin
	select '' as etat,id_type_loge,nom_type_loge,lib_type_loge,id_deg from type_loge order by nom_type_loge;
end; //
delimiter ;
-------------------------
-- drop procedure AZtype_offMaj;
delimiter //
create procedure AZtype_offMaj (p_etat char,p_id_type_off int,p_code_type_off varchar(10),p_nom_type_off varchar(100),p_num_off int,p_id_deg int,p_id_rite int)
begin
	if (p_etat ='U') then
		update type_off set code_type_off=p_code_type_off,nom_type_off=p_nom_type_off,num_off=p_num_off,id_deg=p_id_deg,id_rite=p_id_rite where id_type_off=p_id_type_off;
	elseif (p_etat = 'I') then
		insert into type_off (code_type_off,nom_type_off,num_off,id_deg,id_rite) values (p_code_type_off,p_nom_type_off,p_num_off,p_id_deg,p_id_rite);
	elseif (p_etat = 'D') then
		delete from type_off where id_type_off=p_id_type_off;
	end if;
end; //
delimiter ;

-- drop procedure AZtype_offSelect;
delimiter //
create procedure AZtype_offSelect ()
begin
	select '' as etat,id_type_off,code_type_off,nom_type_off,num_off,d.id_deg,d.nom_deg as id_degWITH,tof.id_rite,r.nom_rite as id_riteWITH
		from type_off tof
		left outer join deg d on tof.id_deg=d.id_deg
		left outer join rite r on tof.id_rite=r.id_rite
		order by d.id_deg,num_off,nom_type_off;
end; //
delimiter ;
-------------------------
-- drop procedure AZtype_tenueMaj;
delimiter //
create procedure AZtype_tenueMaj (p_etat char,p_id_type_tenue int,p_nom_type_tenue varchar(30),p_lib_type_tenue varchar(80),p_id_deg int)
begin
	if (p_etat ='U') then
		update type_tenue set nom_type_tenue=p_nom_type_tenue,lib_type_tenue=p_lib_type_tenue,id_deg=p_id_deg where id_type_tenue=p_id_type_tenue;
	elseif (p_etat = 'I') then
		insert into type_tenue (nom_type_tenue,lib_type_tenue,id_deg) values (p_nom_type_tenue,p_lib_type_tenue,p_id_deg);
	elseif (p_etat = 'D') then
		delete from type_tenue where id_type_tenue=p_id_type_tenue;
	end if;
end; //
delimiter ;

-- drop procedure AZtype_tenueSelect;
delimiter //
create procedure AZtype_tenueSelect ()
begin
	select '' as etat,t.id_type_tenue,t.nom_type_tenue,t.lib_type_tenue,t.id_deg,d.nom_deg as id_degWITH
		from type_tenue t
		inner join deg d on t.id_deg=d.id_deg
		order by t.nom_type_tenue;
end; //
delimiter ;
-------------------------
-- drop procedure AZvilleMaj;
delimiter //
create procedure AZvilleMaj (p_etat char,p_id_ville int,p_nom_ville varchar(30),p_code_postal varchar(30))
begin
	if (p_etat ='U') then
		update ville set nom_ville=p_nom_ville,code_postal=p_code_postal where id_ville=p_id_ville;
	elseif (p_etat = 'I') then
		insert into ville (nom_ville,code_postal) values (p_nom_ville,p_code_postal);
	elseif (p_etat = 'D') then
		delete from ville where id_ville=p_id_ville;
	end if;
end; //
delimiter ;

-- drop procedure AZvilleSelect;
delimiter //
create procedure AZvilleSelect ()
begin
	select '' as etat,id_ville,nom_ville,code_postal from ville order by nom_ville;
end; //
delimiter ;
----------------------------
-- drop procedure valider_prs;
delimiter //
create procedure valider_prs (p_id_prs int,p_cle varchar(200))
begin
	declare v_nb int;
	declare v_ret char(2);
	select count(*) into v_nb from prs where id_prs=p_id_prs and cle=p_cle;
	set v_ret=case v_nb when 1 then 'OK' else 'KO' end;
	select v_ret;
end; //
delimiter ;
----------------------------
-- drop procedure AZvalider_prs_mdp;
delimiter //
create procedure AZvalider_prs_mdp (p_id_prs int,p_cle varchar(200))
begin
	declare v_nb int;
	declare v_ret varchar(10);
	declare v_niv_lec int;
	declare v_niv_ecr int;
	declare v_niv_exp int;
	select count(*) into v_nb from prs where id_prs=p_id_prs and mdp=p_cle;
	if(v_nb>0)then
		select case isnull(nivo_lec) when 1 then 1 else nivo_lec end,
			case isnull(nivo_ecr) when 1 then 1 else nivo_ecr end,
			case isnull(nivo_exp) when 1 then 1 else nivo_exp end
			 into v_niv_lec,v_niv_ecr,v_niv_exp
			from prs where id_prs=p_id_prs;
		set v_ret=concat(v_niv_lec,'|',v_niv_ecr,'|',v_niv_exp);
	else
		set v_ret='-1|-1|-1';
	end if;
	select v_ret;
end; //
delimiter ;
----------------------------
-- drop procedure AZmdp_prs;
delimiter //
create procedure AZmdp_prs (p_id_prs int,p_cle varchar(200))
begin
	update prs set cle=p_cle where id_prs=p_id_prs;
	select 'OK';
end; //
delimiter ;
----------------------------
-- drop procedure ap_debog;
delimiter //
create procedure ap_debog (p_msg varchar(200))
begin
	declare v_date_debog datetime;
	select current_date() into v_date_debog;
	insert into debog(date_msg,msg) values (v_date_debog,p_msg);
end; //
delimiter ;
----------------------------
-- drop procedure AZinit_cbo;
delimiter //
create procedure AZinit_cbo (p_nom_tab varchar(200))
begin
	if (p_nom_tab='cerem') then
		select id_cerem,nom_cerem from cerem order by 2;
	elseif (p_nom_tab='deg') then
		select id_deg,nom_deg from deg order by 2;
	elseif (p_nom_tab='deg_bl') then
		select id_deg,nom_deg from deg where avancement=0 order by 2;
	elseif (p_nom_tab='deg_av') then
		select id_deg,nom_deg from deg where avancement=1 order by 2;
	elseif(p_nom_tab='etat_prs') then
		select id_etat_prs,nom_etat_prs from etat_prs order by 2;
	elseif(p_nom_tab='loge') then
		select id_loge,nom_loge from loge order by 2;
	elseif(p_nom_tab='loge_tenue') then
		select id_loge_tenue,date_tenue from loge_tenue order by 2;
	elseif(p_nom_tab='loge_tenue_deb') then
		select id_loge_tenue,date_tenue from loge_tenue order by 2;
	elseif(p_nom_tab='loge_tenue_fin') then
		select id_loge_tenue,date_tenue from loge_tenue order by 2;
	elseif (p_nom_tab='obed') then
		select id_obed,nom_obed from obed order by 2;
	elseif (p_nom_tab='orient') then
		select id_orient,nom_orient from orient order by 2;
	elseif (p_nom_tab='prs') then
		select id_prs,concat(nom_prs,' ',prenom_prs) from prs order by 2;
	elseif (p_nom_tab='prs_login') then
		select id_prs,concat(nom_prs,' ',prenom_prs) from prs where id_etat_prs in (select id_etat_prs from etat_prs where actif=1) and mdp is not null order by 2;
	elseif (p_nom_tab='rite') then
		select id_rite,nom_rite from rite order by 2;
	elseif (p_nom_tab='temple') then
		select id_temple,nom_temple from temple order by 2;
	elseif (p_nom_tab='terr') then
		select id_terr,lib_terr from terr order by 2;
	elseif (p_nom_tab='type_doc') then
		select id_type_doc,nom_type_doc from type_doc order by 2;
	elseif (p_nom_tab='type_fic') then
		select id_type_fic,nom_type_fic from type_fic order by 2;
	elseif (p_nom_tab='type_loge') then
		select id_type_loge,lib_type_loge from type_loge order by 2;
	elseif (p_nom_tab='type_off') then
		select id_type_off,nom_type_off from type_off order by num_off;
	elseif (p_nom_tab='type_tenue') then
		select id_type_tenue,nom_type_tenue from type_tenue order by 2;
	elseif (p_nom_tab='ville') then
		select id_ville,concat(code_postal,' ',nom_ville) from ville order by 2;
	end if;
end; //
delimiter ;
----------------------------
-- drop procedure AZinit_cbo_bis;
delimiter //
create procedure AZinit_cbo_bis (p_nom_tab varchar(200),p_id int)
begin
	if(p_nom_tab='loge_tenue_deb') then
		select t.id_loge_tenue,concat(cast(t.date_tenue as Date),case isnull(c.nom_cerem) when 1 then '' else concat(' (',c.nom_cerem,')') end)
		from loge_tenue t
		left outer join cerem c on t.id_cerem=c.id_cerem
		where t.id_loge=p_id order by 2;
	elseif(p_nom_tab='loge_tenue_fin') then
		select t.id_loge_tenue,concat(cast(t.date_tenue as Date),case isnull(c.nom_cerem) when 1 then '' else concat(' (',c.nom_cerem,')') end)
		from loge_tenue t
		inner join loge_tenue td on td.id_loge_tenue=p_id and t.id_loge=td.id_loge and t.date_tenue>td.date_tenue
		left outer join cerem c on t.id_cerem=c.id_cerem
		order by 2;
	end if;
end; //
delimiter ;
