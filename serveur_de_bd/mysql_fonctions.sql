drop function fct_tenue_prs;
delimiter //
create function fct_tenue_prs (p_id_loge_tenue int)
returns varchar(500)
begin
	declare v_prs varchar(200) default '';
	declare v_liste_prs varchar(500) default '';
	declare v_c_prs_ok int default 1;
	declare c_prs cursor for
		select concat(p.nom_prs,' ',p.prenom_prs,case isnull(t.nom_trv) when 0 then concat(' (',t.nom_trv,')') else '' END)
		from prs p
		inner join prs_trv t on t.id_prs=p.id_prs
		where t.id_loge_tenue=p_id_loge_tenue
		union
		select concat(p.nom_prs,' ',p.prenom_prs)
		from prs p
		inner join prs_off o on o.id_prs=p.id_prs
		where o.id_loge_tenue_deb=p_id_loge_tenue
		union
		select concat(p.nom_prs,' ',p.prenom_prs)
		from prs p
		inner join prs_off o on o.id_prs=p.id_prs
		where o.id_loge_tenue_fin=p_id_loge_tenue
		union
		select concat(p.nom_prs,' ',p.prenom_prs)
		from prs p
		inner join prs_deg d on d.id_prs=p.id_prs
		where d.id_loge_tenue=p_id_loge_tenue
		order by 1;
	declare continue handler for not found set v_c_prs_ok=0;
	open c_prs;
	while(v_c_prs_ok=1) do
		fetch c_prs into v_prs;
		if(v_c_prs_ok=1) then		
			if(length(v_liste_prs)>0) then
				set v_liste_prs=concat(v_liste_prs,', ');
			end if;
			set v_liste_prs=concat(v_liste_prs,v_prs);
		end if;
	end while;
	close c_prs;
	return v_liste_prs;
end; //
delimiter ;

drop function fct_aff_date;
delimiter //
create function fct_aff_date(var_date datetime)
returns varchar(20)
begin
	return substring(convert(var_date,char),1,10);
end; //

drop function fct_rep;
delimiter //
create function fct_rep(nom_tab varchar(30),id int)
returns varchar(500)
begin
	declare rep varchar(500) default '';
	declare id_bis int;
	declare id_ter int;
	declare v_temp varchar(500);
	if(nom_tab='AZecr') then
		select nom_ecr into rep from AZecr where id_AZecr=id;
	elseif(nom_tab='AZonglet') then
		select entete into rep from AZonglet where id_AZonglet=id;
	elseif(nom_tab='AZtype_champ') then
		select nom_type_champ into rep from AZtype_champ where id_AZtype_champ=id;
	elseif(nom_tab='cerem') then
		select nom_cerem into rep from cerem where id_cerem=id;
	elseif(nom_tab='deg') then
		select nom_deg into rep from deg where id_deg=id;
	elseif(nom_tab='etat_prs') then
		select nom_etat_prs into rep from etat_prs where id_etat_prs=id;
	elseif(nom_tab='loge') then
		select nom_loge into rep from loge where id_loge=id;
	elseif(nom_tab='loge_tenue') then
		select concat(l.nom_loge,' ',convert(t.date_tenue,char)) into rep from loge_tenue t inner join loge l on t.id_loge=l.id_loge where id_loge_tenue=id;
	elseif(nom_tab='loge_tenue_descr') then
		select id_type_tenue,id_cerem,lib_tenue into id_bis,id_ter,v_temp from loge_tenue where id_loge_tenue=id;
		if(id_ter is not null) then
			select nom_cerem into rep from cerem where id_cerem=id_ter;
		elseif (id_bis is not null) then
			select nom_type_tenue into rep from type_tenue where id_type_tenue=id_bis;
		end if;
		if(length(rep)>0) then
			if(v_temp is not null) then
				set rep=concat(rep,' (',v_temp,')');
			end if;
		else
			set rep=v_temp;
		end if;
	elseif(nom_tab='obed') then
		select nom_obed into rep from obed where id_obed=id;
	elseif(nom_tab='orient') then
		select nom_orient into rep from orient where id_orient=id;
	elseif(nom_tab='prs') then
		select concat(nom_prs,' ',prenom_prs) into rep from prs where id_prs=id;
	elseif(nom_tab='prs_doc') then
		select case isnull(nom_doc) when 1 then '' else nom_doc end into v_temp from prs_doc where id_prs_doc=id;
		select concat(t.nom_type_doc,': ',v_temp) into rep from prs_doc d inner join type_doc t on d.id_type_doc=t.id_type_doc where id_prs_doc=id;
	elseif(nom_tab='prs_loge') then
		select concat(nom_loge,':',nom_prs,' ',prenom_prs) into rep
			from prs_loge pl
			inner join prs p on pl.id_prs=p.id_prs
			inner join loge l on pl.id_loge=l.id_loge
			where id_prs_loge=id;
	elseif(nom_tab='prs_off') then
		select concat(l.nom_loge,':',t.type_off,': ',convert(d.date_tenue,char),case isnull(f.date_tenue) when 1 then '' else concat('->',convert(f.date_tenue,char))end) into rep
			from prs_off o
			inner join type_off t on o.id_type_off=t.id_type_off
			inner join loge_tenue d on o.id_loge_tenue_deb=d.id_loge_tenue
			inner join loge l on d.id_loge=l.id_loge
			left outer join loge_tenue f on o.id_loge_tenue_fin=f.id_loge_tenue
			where id_prs_off=id;
	elseif(nom_tab='prs_trv') then
		select concat(case isnull(c.nom_cerem) when 1 then '' else concat(c.nom_cerem,' ') end,case isnull(nom_trv) when 1 then case isnull(lib_tenue) when 1 then '' else lib_tenue end else nom_trv end) into rep
		from prs_trv t
		inner join loge_tenue lt on t.id_loge_tenue=lt.id_loge_tenue
		left outer join cerem c on lt.id_cerem=c.id_cerem
		where id_prs_trv=id;
	elseif(nom_tab='rite') then
		select nom_rite into rep from rite where id_rite=id;
	elseif(nom_tab='temple') then
		select lib_temple into rep from temple where id_temple=id;
	elseif(nom_tab='tenue_date') then
		select convert(convert(t.date_tenue,date),char) into rep from loge_tenue t where id_loge_tenue=id;
	elseif(nom_tab='terr') then
		select nom_terr into rep from terr where id_terr=id;
	elseif(nom_tab='type_doc') then
		select nom_type_doc into rep from type_doc where id_type_doc=id;
	elseif(nom_tab='type_fic') then
		select nom_type_fic into rep from type_fic where id_type_fic=id;
	elseif(nom_tab='type_loge') then
		select nom_type_loge into rep from type_loge where id_type_loge=id;
	elseif(nom_tab='type_off') then
		select nom_type_off into rep from type_off where id_type_off=id;
	elseif(nom_tab='type_req_crit') then
		select nom_type_req_crit into rep from type_req_crit where id_type_req_crit=id;
	elseif(nom_tab='type_tenue') then
		select nom_type_tenue into rep from type_tenue where id_type_tenue=id;
	elseif (nom_tab='ville') then
		select nom_ville into rep from ville where id_ville=id;
	else
		set rep=concat(nom_tab,id);
	end if;
	return rep;
end; //
delimiter ;

drop function AZliste_colonnes_par_index;
delimiter //
create function AZliste_colonnes_par_index(p_nom_idx varchar(30))
returns varchar(500)
begin
	declare v_liste_cols varchar(500) default '';
	declare	v_c_cols_ok int default 1;
	declare v_nom_col varchar(30) default '';
	declare c_cols cursor for
		select c.name
		from information_schema.innodb_sys_fields c
		inner join information_schema.innodb_sys_indexes i on i.index_id=c.index_id
		where i.name=p_nom_idx
		order by c.pos;
	declare continue handler for not found set v_c_cols_ok=0;
	open c_cols;
	while(v_c_cols_ok=1) do
		fetch c_cols into v_nom_col;
		if(v_c_cols_ok=1) then
			if(length(v_liste_cols)>0) then
				set v_liste_cols=concat(v_liste_cols,', ');
			end if;
			set v_liste_cols=concat(v_liste_cols,v_nom_col);
		end if;
	end while;
	close c_cols;
	return v_liste_cols;
end; //
delimiter ;
