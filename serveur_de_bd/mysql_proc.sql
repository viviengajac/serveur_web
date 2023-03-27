
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

---------------------------
-- drop procedure AZprs__prsMaj;
delimiter //
create procedure AZprs__prsMaj (p_etat char,p_id_prs int,p_nom_prs varchar(30),p_prenom_prs varchar(20),p_id_etat_prs int)
begin
	if (p_etat ='U') then
		update prs set nom_prs=p_nom_prs,prenom_prs=p_prenom_prs,id_etat_prs=p_id_etat_prs where id_prs=p_id_prs;
	elseif (p_etat = 'I') then
		insert into prs (nom_prs,prenom_prs,id_etat_prs) values (p_nom_prs,p_prenom_prs,1);
	elseif (p_etat = 'D') then
		delete from prs where id_prs=p_id_prs;
	end if;
end; //
delimiter ;

-- drop procedure AZprs__prsSelect;
delimiter //
create procedure AZprs__prsSelect (in p_id_prs int)
begin
	select '' as etat,p.id_prs,p.nom_prs,p.prenom_prs,p.id_etat_prs,e.nom_etat_prs as id_etat_prsWITH,e.actif
	from prs p
	inner join etat_prs e on p.id_etat_prs=e.id_etat_prs
 where id_prs=p_id_prs;
 end; //
delimiter ;
------------------------------------



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
-- drop procedure AZinit_cbo; DANS LA BD
delimiter //
create procedure AZinit_cbo (p_nom_tab varchar(200))
begin
	if (p_nom_tab='prs') then
		select id_prs,concat(nom_prs,' ',prenom_prs) from prs order by 2;
	elseif(p_nom_tab='etat_prs') then
		select id_etat_prs,nom_etat_prs from etat_prs order by 2;
	elseif (p_nom_tab='prs_login') then
		select id_prs,concat(nom_prs,' ',prenom_prs) from prs order by 2;
	elseif (p_nom_tab='actions') then
		select id_actions,nom from actions order by 2;
	elseif (p_nom_tab='transactions') then
		select id_actions,nom from actions order by 2;
	elseif (p_nom_tab='transetat') then
		select id_transetat,lib_transetat from transetat order by 2;
	end if;
end; //
delimiter ;
-----------
-- drop procedure AZinit_cbo_bis _actions; DANS LA BD
delimiter //
create procedure AZinit_cbo_bis (p_nom_tab varchar(200),p_id int)
begin
	if(p_nom_tab='transactions') then
		select id_actions,nom from actions order by 2;
	elseif (p_nom_tab='transetat') then
		select id_transetat,lib_transetat from transetat order by 2;
	end if;
end; //
delimiter ;
-----
	elseif (p_nom_tab='transactions') then
		select t.id_actions,a.nom from actions a inner join transactions t on t.id_actions=a.id_actions order by 2;
		-----
-- drop procedure AZinit_cbo; test
delimiter //
create procedure AZinit_cbo (p_nom_tab varchar(200))
begin
	if (p_nom_tab='prs') then
		select id_prs,concat(nom_prs,' ',prenom_prs) from prs order by 2;
	elseif(p_nom_tab='etat_prs') then
		select id_etat_prs,nom_etat_prs from etat_prs order by 2;
	elseif (p_nom_tab='prs_login') then
		select id_prs,concat(nom_prs,' ',prenom_prs) from prs order by 2;
	elseif (p_nom_tab='actions') then
		select id_actions,nom from actions order by 2;
	elseif (p_nom_tab='transactions') then
		select a.id_actions,a.nom from actions a inner join transactions t on t.id_actions=a.id_actions order by 2;
	end if;
end; //
delimiter ;
-----
-----
	elseif (p_nom_tab='transetat') then
		select t2.id_transetat,t1.lib_transetat from transetat t1 inner join transactions t2 on t1.id_transetat=t2.id_transetat order by 2;
----------------------------
-- drop procedure AZinit_cbo_bis; _actions;
delimiter //
create procedure AZinit_cbo_bis (p_nom_tab varchar(200),p_id int)
begin
	if(p_nom_tab='transactions') then
		select a.id_actions,a.nom
		from actions a
		inner join transactions t on t.id_actions=a.id_actions
		order by 2;
	end if;
end; //
delimiter ;
----

---------------------------
ALTER TABLE transactions ADD CONSTRAINT fk_transactions_transetat FOREIGN KEY (id_transetat) REFERENCES transetat(id_transetat);
----------------------------
drop procedure AZactionsMaj;
delimiter //
create procedure AZactionsMaj (p_etat char,p_id_actions int,p_nom varchar(20),p_symbole varchar(10),p_cumul int)
begin
    if (p_etat ='U') then
-- select current_date() into v_date_debog;
-- insert into debog(date_msg,msg) values (v_date_debog,concat('AZloge__tenueMaj: lib_tenue=',p_lib_tenue));
        update actions set nom=p_nom,symbole=p_symbole,cumul=p_cumul where id_actions=p_id_actions;
    elseif (p_etat = 'I') then
        insert into actions (nom,symbole,cumul) values (p_nom,p_symbole,p_cumul);
    elseif (p_etat = 'D') then
        delete from actions where id_actions=p_id_actions;
    end if;
end; //
delimiter ;

drop procedure AZactionsSelect;
delimiter //
create procedure AZactionsSelect ()
begin
    select '' as etat,id_actions,nom,symbole,cumul from actions order by nom;
end; //
delimiter ;
------------------
-- drop procedure AZactions__recherche;
delimiter //
create procedure AZactions__recherche (p_nom varchar(20))
begin
	select A.id_actions,A.nom,A.symbole,A.cumul
		FROM actions A
		  where 1=1
			  and (A.nom like p_nom or p_nom is null)
		ORDER BY A.nom;
end; //
delimiter ;
-------
-- drop procedure AZactions__actionsSelect;
delimiter //
create procedure AZactions__actionsSelect (in p_id_actions int)
begin
	select '' as etat,A.id_actions,A.nom,A.symbole,A.cumul
	from actions A
	where id_actions=p_id_actions;
end; //
delimiter ;
-----
-- drop procedure AZactions__actionsMaj;
delimiter //
create procedure AZactions__actionsMaj (p_etat char,p_id_actions int,p_nom varchar(20),p_symbole varchar(20),p_cumul int)
begin
	if (p_etat ='U') then
-- select current_date() into v_date_debog;
-- insert into debog(date_msg,msg) values (v_date_debog,concat('AZloge__tenueMaj: lib_tenue=',p_lib_tenue));
		update actions set nom=p_nom,symbole=p_symbole,cumul=p_cumul where id_actions=p_id_actions;
	elseif (p_etat = 'I') then
		insert into actions (nom,symbole,cumul) values (p_nom,p_symbole,p_cumul);
	elseif (p_etat = 'D') then
		delete from actions where id_actions=p_id_actions;
	end if;
end; //
delimiter ;
---
-- drop procedure AZactions__transactionsSelect;
delimiter //
create procedure AZactions__transactionsSelect (in p_id_actions int)
begin
	select '' as etat,T.id_transactions,T.id_actions,T.date_achat,T.nb_achat,T.prix_achat,T.frais_achat,T.cac_achat,T.date_vente,T.nb_vente,T.prix_vente,T.frais_vente,T.cac_vente,T.id_transetat
	from transactions T
	where id_actions=p_id_actions;
end; //
delimiter ;
-----
-- drop procedure AZactions__transactionsMaj;  OLD
delimiter //
create procedure AZactions__transactionsMaj (p_etat char,p_id_actions int,p_date_achat datetime,p_nb_achat int,p_cac_achat int,p_date_vente datetime,p_nb_vente int,p_cac_vente int,p_id_transetat int)
begin
	if (p_etat ='U') then
-- select current_date() into v_date_debog;
-- insert into debog(date_msg,msg) values (v_date_debog,concat('AZloge__tenueMaj: lib_tenue=',p_lib_tenue));
		update transactions set id_actions=p_id_actions,date_achat=p_date_achat,nb_achat=p_nb_achat,cac_achat=p_cac_achat,date_vente=p_date_vente,nb_vente=p_nb_vente,cac_vente=p_cac_vente,id_transetat=p_id_transetat where id_transactions=p_id_transactions;
	elseif (p_etat = 'I') then
		insert into transactions (id_actions,date_achat,nb_achat,cac_achat,date_vente,nb_vente,cac_vente,id_transetat) values (p_date_achat,p_nb_achat,p_cac_achat,p_date_vente,p_nb_vente,p_cac_vente,p_id_transetat);
	elseif (p_etat = 'D') then
		delete from transactions where id_transactions=p_id_transactions;
	end if;
end; //
delimiter ;

----------------
--CORRECTION AZactions__transactionsMaj  - ne fonctionne pas -
----------------
delimiter //
create procedure AZactions__transactionsMaj (p_etat char,p_id_actions int,p_date_achat varchar(20),p_nb_achat int,p_prix_achat int,p_frais_achat int,p_cac_achat int,p_date_vente varchar(20),p_nb_vente int,p_prix_vente int,p_frais_vente int,p_cac_vente int,p_id_transetat int)
begin
	if (p_etat ='U') then
-- select current_date() into v_date_debog;
-- insert into debog(date_msg,msg) values (v_date_debog,concat('AZloge__tenueMaj: lib_tenue=',p_lib_tenue));
		update transactions set id_actions=p_id_actions,date_achat=p_date_achat,nb_achat=p_nb_achat,prix_achat=p_prix_achat,frais_achat=p_frais_achat,cac_achat=p_cac_achat,date_vente=p_date_vente,nb_vente=p_nb_vente,prix_vente=p_prix_vente,frais_vente=p_frais_vente,cac_vente=p_cac_vente,id_transetat=p_id_transetat where id_transactions=p_id_transactions;
	elseif (p_etat = 'I') then
		insert into transactions (id_actions,date_achat,nb_achat,prix_achat,frais_achat,cac_achat,date_vente,nb_vente,prix_vente,frais_vente,cac_vente,transetat) values (p_date_achat,p_nb_achat,p_prix_achat,p_frais_achat,p_cac_achat,p_date_vente,p_nb_vente,p_prix_vente,p_frais_vente,p_cac_vente,p_id_transetat);
	elseif (p_etat = 'D') then
		delete from transactions where id_transactions=p_id_transactions;
	end if;
end
delimiter ;

------ fonctionne
-- drop procedure AZactions__transactionsMaj;
delimiter //
create procedure AZactions__transactionsMaj (p_etat char,p_id_transactions int,p_id_actions int,p_date_achat datetime,p_nb_achat int,p_prix_achat float,p_frais_achat float,p_cac_achat int,p_date_vente datetime,p_nb_vente int,p_prix_vente float,p_frais_vente float,p_cac_vente int,p_id_transetat int)
begin
	if (p_etat ='U') then
-- select current_date() into v_date_debog;
-- insert into debog(date_msg,msg) values (v_date_debog,concat('AZloge__tenueMaj: lib_tenue=',p_lib_tenue));
		update transactions set id_transactions=p_id_transactions,id_actions=p_id_actions,date_achat=p_date_achat,nb_achat=p_nb_achat,prix_achat=p_prix_achat,frais_achat=p_frais_achat,cac_achat=p_cac_achat,date_vente=p_date_vente,nb_vente=p_nb_vente,prix_vente=p_prix_vente,frais_vente=p_frais_vente,cac_vente=p_cac_vente,id_transetat=p_id_transetat where id_transactions=p_id_transactions;
	elseif (p_etat = 'I') then
		insert into transactions (id_transactions,id_actions,date_achat,nb_achat,prix_achat,frais_achat,cac_achat,date_vente,nb_vente,prix_vente,frais_vente,cac_vente,id_transetat) values (p_id_transactions,p_id_actions,p_date_achat,p_nb_achat,p_prix_achat,p_frais_achat,p_cac_achat,p_date_vente,p_nb_vente,p_prix_vente,p_frais_vente,p_cac_vente,p_id_transetat);
	elseif (p_etat = 'D') then
		delete from transactions where id_transactions=p_id_transactions;
	end if;
end; //
delimiter ;

------------------
--AZcmptMaj pour angular 15 (tests)
begin
    if(p_id_instr!=0) then
		if (p_etat ='U') then
			update cmpt set nom_cmpt=p_nom_cmpt,id_instr=p_id_instr,grands=p_grands,moyens=p_moyens,petits=p_petits where id_cmpt=p_id_cmpt;
		elseif (p_etat = 'I') then
			insert into cmpt (nom_cmpt,id_instr,grands,moyens,petits) values (p_nom_cmpt,p_id_instr,p_grands,p_moyens,p_petits);
		elseif (p_etat = 'D') then
			delete from cerem where id_cmpt=p_id_cmpt;
		end if;
    else then
    	if (p_etat ='U') then
			update cmpt set nom_cmpt=p_nom_cmpt,id_instr=null,grands=p_grands,moyens=p_moyens,petits=p_petits where id_cmpt=p_id_cmpt;
		elseif (p_etat = 'I') then
			insert into cmpt (nom_cmpt,id_instr,grands,moyens,petits) values (p_nom_cmpt,null,p_grands,p_moyens,p_petits);
		elseif (p_etat = 'D') then
			delete from cerem where id_cmpt=p_id_cmpt;			
		end if;
	end if;
end
-- 
if(p_id_instr!=0) then
	begin
	if (p_etat ='U') then
			update cmpt set nom_cmpt=p_nom_cmpt,id_instr=p_id_instr,grands=p_grands,moyens=p_moyens,petits=p_petits where id_cmpt=p_id_cmpt;
		elseif (p_etat = 'I') then
			insert into cmpt (nom_cmpt,id_instr,grands,moyens,petits) values (p_nom_cmpt,p_id_instr,p_grands,p_moyens,p_petits);
		elseif (p_etat = 'D') then
			delete from cerem where id_cmpt=p_id_cmpt;
		end if;
	end
else
	begin
	    if (p_etat ='U') then
			update cmpt set nom_cmpt=p_nom_cmpt,id_instr=null,grands=p_grands,moyens=p_moyens,petits=p_petits where id_cmpt=p_id_cmpt;
		elseif (p_etat = 'I') then
			insert into cmpt (nom_cmpt,id_instr,grands,moyens,petits) values (p_nom_cmpt,null,p_grands,p_moyens,p_petits);
		elseif (p_etat = 'D') then
			delete from cerem where id_cmpt=p_id_cmpt;			
		end if;
	end

-- (fin test AZcmptMaj)

-- AZinterv__recherche (test)
begin
select i.id_interv,i.date_interv,i.id_seance,i.id_lieu,i.comm_interv,i.tarif_interv,i.fact_interv,i.num_interv,s.id_seance,s.nom_seance,l.id_lieu,l.nom_lieu
	from interv i
    left join seance s
    on i.id_seance=s.id_seance
    left join lieu l
    on l.id_lieu=i.id_lieu
		where 1=1
		ORDER BY i.id_interv;
end
-- fonctionne :
begin
select i.id_interv,i.date_interv,i.id_seance,i.id_lieu,i.comm_interv,i.tarif_interv,i.fact_interv,i.num_interv,s.id_seance,s.nom_seance,l.id_lieu,l.nom_lieu
	from interv i
    left join seance s
    on i.id_seance=s.id_seance
    left join lieu l
    on l.id_lieu=i.id_lieu
	where (i.date_interv > p_date_interv_mini OR p_date_interv_mini is null) AND (i.date_interv < p_date_interv_maxi OR p_date_interv_maxi is null) AND (i.id_seance = p_id_seance OR p_id_seance is null) AND (i.id_lieu = p_id_lieu OR p_id_lieu is null)
	ORDER BY i.id_interv;
end

-- fin test AZinterv__recheche

-- ok:
begin
	if (p_etat ='U') then
-- select current_date() into v_date_debog;
-- insert into debog(date_msg,msg) values (v_date_debog,concat('AZloge__tenueMaj: lib_tenue=',p_lib_tenue));
		update seance set nom_seance=p_nom_seance,num_seance=p_num_seance where id_seance=p_id_seance;
	elseif (p_etat = 'I') then
		insert into seance (nom_seance,num_seance) values (p_nom_seance,p_num_seance);
	elseif (p_etat = 'D') then
		delete from seance where id_seance=p_id_seance;
	end if;
end

--AZ_init_cbo 2023

begin
	if (p_nom_tab='prs') then
		select id_prs,concat(nom_prs,' ',prenom_prs) from prs order by 2;
    elseif(p_nom_tab='seance') then
		select id_seance,nom_seance from seance where nom_seance is not null order by 2;
    elseif(p_nom_tab='lieu') then
		select id_lieu,nom_lieu from lieu order by 2;
    elseif(p_nom_tab='cmpt') then
		select id_cmpt,nom_cmpt from cmpt order by 2;
	elseif(p_nom_tab='instr') then
		select id_instr,nom_instr from instr order by 2;
	elseif(p_nom_tab='etat_prs') then
		select id_etat_prs,nom_etat_prs from etat_prs order by 2;
	elseif (p_nom_tab='prs_login') then
		select id_prs,concat(nom_prs,' ',prenom_prs) from prs order by 2;
	elseif (p_nom_tab='actions') then
		select id_actions,nom from actions order by 2;
	elseif (p_nom_tab='transactions') then
		select id_actions,nom from actions order by 2;
	elseif (p_nom_tab='transetat') then
		select id_transetat,lib_transetat from transetat order by 2;
	end if;
end