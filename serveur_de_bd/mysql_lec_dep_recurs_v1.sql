drop procedure lec_dep_recurs;
delimiter //
create PROCEDURE lec_dep_recurs(in p_sens varchar(1),in p_nom_tab varchar(50),in p_id int,p_niveau int,in p_max_lignes int,in p_profondeur int,out p_retour char(2))
begin
	declare	v_niv2 int;
	declare	v_nb_cles int;
	declare	v_nom_col varchar(80);
	declare	v_nom_tab2 varchar(80);
	declare	v_nom_col2 varchar(80);
	declare	v_nom_pk varchar(80);
	declare	v_i	int;
	declare	v_j	int;
	declare	v_id2 int;
	declare	v_nb_id	int;
	declare	v_sql varchar(300);
	declare	v_nb_dep int;
	declare	v_err int;
	declare	v_faire	int;
	declare	v_num_instr int;
	declare	v_msg_erreur varchar(500);
	declare	v_val_erreur varchar(50);
	declare	v_ajout int;
	declare	v_min_ind int;
	declare	v_max_ind int;
	declare	v_ligne varchar(50);
	declare	v_nb int;
	declare	v_app_ds_dep bit;
	declare v_min_cle int;
	declare v_max_cle int;
	declare v_retour_recurs char(2);
	declare v_debog bit;
	DECLARE exit handler for SQLEXCEPTION
	BEGIN
--					GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
--					SET @full_error = CONCAT("ERROR ", @errno, " (", @sqlstate, "): ", @text);
--					SELECT @full_error;
		GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
		set v_msg_erreur=concat('Erreur SQL :',@text);
-- call ap_debog('erreur sql');
-- call ap_debog(v_msg_erreur);
-- call ap_debog(v_msg_erreur);
-- call ap_debog(v_msg_erreur);
		if (p_sens = 'B') then
			insert into temp_dep (niv,nom_tab,id,info) values (p_niveau+1,v_nom_tab2,null,v_msg_erreur);
		else
			insert into temp_dep (niv,nom_tab,id,info) values (p_niveau+1,p_nom_tab,null,v_msg_erreur);
		end if;
--		select count(*) into v_nb from INFORMATION_SCHEMA.TABLES where TABLE_NAME='temp_tab_id';
--		if (v_nb>0) then
--			drop table temp_tab_id;
--		end if;
		set p_retour='KO';
	END;
	set v_debog=1;
-- call ap_debog ('lec_dep_recurs 1');
-- call ap_debog ('lec_dep_recurs 3');
	if(v_debog=1) then
		call ap_debog(concat('debut de lec_dep_recurs(',p_sens,',',p_nom_tab,',',p_id,',',p_niveau,',',p_profondeur,')'));
	end if;
-- exec ap_debog @ligne
	if (p_niveau > 0) then
		select count(*) into v_nb from temp_dep where nom_tab=p_nom_tab and id=p_id;
		if (v_nb = 0) then
-- call ap_debog(concat('insertion d''une dependance(niveau=',p_niveau,', nom_tab=',p_nom_tab,', id=',p_id));
			insert into temp_dep (niv,nom_tab,id) values (p_niveau,p_nom_tab,p_id);
			set v_faire=1;
		else
			set v_faire=0;
		end if;
	else
		set v_faire=1;
	end if;
-- call ap_debog ('lec_dep_recurs 4');
-- print 'faire='+convert(varchar,@faire)
	set v_niv2=p_niveau+1;
	if (v_faire>0 and v_niv2<32 and v_niv2<=p_profondeur) then-- Nombre d'imbrication dans T-sql doit être inférieur a 32
-- print 'filtre passe'
-- call ap_debog ('lec_dep_recurs 5');
		if (p_sens = 'B') then
			if (p_nom_tab = 'prsaaa') then
				set v_nb=0;
			else
				set v_faire=1;
--				declare lec_contr cursor for
--					select object_name(fkeyid),col_name(fkeyid,fkey),col_name(rkeyid,rkey),col_name(fkeyid,rkey)
--					from dbo.sysforeignkeys where object_name(rkeyid)=@nom_tab
			end if;
		else
			set v_faire=1;
--			declare lec_contr cursor for
--				select object_name(rkeyid),col_name(rkeyid,rkey),col_name(fkeyid,fkey),col_name(rkeyid,rkey)
--				from dbo.sysforeignkeys where object_name(fkeyid)=@nom_tab
		end if;
		if (v_faire>0) then
			delete from temp_tab_cle where niveau=p_niveau;
-- call ap_debog ('lec_dep_recurs 6');
			if (p_sens = 'B') then
-- call ap_debog ('lec_dep_recurs 7');
-- print 'sens vers le bas'
--				insert into temp_tab_cle(nom_tab2,nom_col2,nom_col,nom_pk)
--					select FK.TABLE_NAME,CU.COLUMN_NAME,CU2.COLUMN_NAME,CU3.COLUMN_NAME
--					FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C
--					INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK ON C.CONSTRAINT_NAME = FK.CONSTRAINT_NAME
--					INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK ON C.UNIQUE_CONSTRAINT_NAME = PK.CONSTRAINT_NAME
--					INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU ON C.CONSTRAINT_NAME = CU.CONSTRAINT_NAME
--					INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK2 on PK2.TABLE_NAME=PK.TABLE_NAME and PK2.CONSTRAINT_TYPE='PRIMARY KEY'
--					INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU2 on PK2.CONSTRAINT_NAME=CU2.CONSTRAINT_NAME
--					INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK3 on PK3.TABLE_NAME=FK.TABLE_NAME and PK3.CONSTRAINT_TYPE='PRIMARY KEY'
--					INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU3 on PK3.CONSTRAINT_NAME=CU3.CONSTRAINT_NAME
--					where FK.CONSTRAINT_TYPE='FOREIGN KEY' and PK.TABLE_NAME = p_nom_tab
--					order by 1,2,3;
-- call ap_debog (concat('avant insertion dans temp_tab_cle pour la table ',p_nom_tab));
				insert into temp_tab_cle(niveau,nom_tab2,nom_col2,nom_col,nom_pk)
					select -1,RC.TABLE_NAME AS FK_TABLE_NAME,KCU.COLUMN_NAME,KCU.REFERENCED_COLUMN_NAME,KCU2.COLUMN_NAME
					FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS AS RC
					inner join INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK on FK.CONSTRAINT_SCHEMA = RC.CONSTRAINT_SCHEMA and FK.CONSTRAINT_NAME = RC.CONSTRAINT_NAME and FK.CONSTRAINT_TYPE = 'FOREIGN KEY'
					inner join INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU on KCU.CONSTRAINT_NAME=RC.CONSTRAINT_NAME
					inner join INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU2 on KCU2.TABLE_NAME=RC.TABLE_NAME
					where rc.referenced_table_NAME=p_nom_tab and KCU2.CONSTRAINT_NAME='PRIMARY'
					order by 1,2,3;
-- call ap_debog ('apres insertion dans temp_tab_cle');
--					select object_name(fkeyid),col_name(fkeyid,fkey),col_name(rkeyid,rkey),col_name(fkeyid,rkey)
--					from dbo.sysforeignkeys where object_name(rkeyid)=@nom_tab
			else
				insert into temp_tab_cle(niveau,nom_tab2,nom_col2,nom_col,nom_pk)
					select -1,RC.REFERENCED_TABLE_NAME AS FK_TABLE_NAME,KCU.COLUMN_NAME,KCU.REFERENCED_COLUMN_NAME,KCU2.COLUMN_NAME
					FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS AS RC
					inner join INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK on FK.CONSTRAINT_SCHEMA = RC.CONSTRAINT_SCHEMA and FK.CONSTRAINT_NAME = RC.CONSTRAINT_NAME and FK.CONSTRAINT_TYPE = 'FOREIGN KEY'
					inner join INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU on KCU.CONSTRAINT_NAME=RC.CONSTRAINT_NAME
					inner join INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU2 on KCU2.TABLE_NAME=RC.TABLE_NAME
					where rc.table_NAME=p_nom_tab and KCU2.CONSTRAINT_NAME='PRIMARY'
					order by 1,2,3;
/*
					select -1,CU.TABLE_NAME,CU.COLUMN_NAME,CU2.COLUMN_NAME,CU.COLUMN_NAME
					FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C
					INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK ON C.CONSTRAINT_NAME = FK.CONSTRAINT_NAME
					INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU2 ON FK.CONSTRAINT_NAME = CU2.CONSTRAINT_NAME
					INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK ON C.UNIQUE_CONSTRAINT_NAME = PK.CONSTRAINT_NAME
					INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU ON C.UNIQUE_CONSTRAINT_NAME = CU.CONSTRAINT_NAME
					where FK.CONSTRAINT_TYPE='FOREIGN KEY' and FK.TABLE_NAME = p_nom_tab
					order by 1,2,3;
*/
--					select object_name(rkeyid),col_name(rkeyid,rkey),col_name(fkeyid,fkey),col_name(rkeyid,rkey)
--					from dbo.sysforeignkeys where object_name(fkeyid)=@nom_tab
			end if;
-- call ap_debog ('lec_dep_recurs 8');
			select count(*) into v_nb from temp_tab_cle where niveau=-1;
			if(v_debog=1) then
				call ap_debog (concat('apres insertion dans tab_cle: nb_cle=',v_nb));
			end if;
			if(v_nb>0) then
				update temp_tab_cle set niveau=p_niveau where niveau=-1;
				select min(ind) into v_min_cle from temp_tab_cle where niveau=p_niveau;
				select max(ind) into v_max_cle from temp_tab_cle where niveau=p_niveau;
				if(v_debog=1) then
					call ap_debog (concat('apres insertion dans tab_cle: min_cle=',v_min_cle,', max cle=',v_max_cle));
				end if;
				set v_i=v_min_cle;
-- call ap_debog ('1');
-- call ap_debog ('2');
				while (v_i<=v_max_cle) do
					delete from temp_tab_id where niveau=p_niveau;
--				delete #tab_id
--				select @nom_col=nom_col,@nom_tab2=nom_tab2,@nom_col2=nom_col2,@nom_pk=nom_pk from temp_tab_cle where ind=v_i;
-- call ap_debog ('3');
					select nom_col,nom_tab2,nom_col2,nom_pk into v_nom_col,v_nom_tab2,v_nom_col2,v_nom_pk from temp_tab_cle where ind=v_i;
-- call ap_debog(concat('nom_col=',v_nom_col,', nom_tab2=',v_nom_tab2,', nom_col2=',v_nom_col2,', nom_pk=',v_nom_pk));
-- call ap_debog ('4');
-- print 'ind='+convert(varchar,@i)+', nom_col='+@nom_col+', nom_tab2='+@nom_tab2+', nom_col2='+@nom_col2+', nom_pk='+@nom_pk
					set v_min_ind=0,v_max_ind=0;
-- call ap_debog ('5');
--				create temporary table temp_tab_id (ind int not null auto_increment, primary key(ind),id int);
					if (p_sens = 'B') then
--						select @sql='declare lect_id cursor global for select '+@nom_pk+' from '+@nom_tab2+' where '+@nom_col2+'='+convert(varchar,@id)
--						select @sql='insert into @tab_id(id) select id_'+@nom_tab2+' from '+@nom_tab2+' where '+@nom_col2+'='+convert(varchar,@id)
-- call ap_debog ('6');
						set @sql=concat('insert into temp_tab_id(niveau,id) select ',p_niveau,',',v_nom_pk,' from ',v_nom_tab2,' where ',v_nom_col2,'=',convert(p_id,char));
-- call ap_debog ('7');
					else
--						select @sql='declare lect_id cursor global for select '+@nom_col+' from '+@nom_tab+' where id_'+@nom_tab+'='+convert(varchar,@id)
--						select @sql='insert into @tab_id(id) select '+@nom_col+' from '+@nom_tab+' where id_'+@nom_tab+'='+convert(varchar,@id)
-- call ap_debog ('6');
						set @sql=concat('insert into temp_tab_id(niveau,id) select ',p_niveau,',',v_nom_col2,' from ',p_nom_tab,' where id_',p_nom_tab,'=',convert(p_id,char));
-- call ap_debog ('7');
					end if;
					if(v_debog=1) then
						call ap_debog(concat('sql dyn=',@sql));
					end if;
-- print 'sql='+isnull(@sql,'sql')
--				BEGIN TRY
-- select @val_erreur=''
-- select @num_instr=0
--					select @min_ind=isnull(min(ind),0) from #tab_id
--					call sp_executesql (v_sql);
					prepare stmt from @sql;
					execute stmt;
					deallocate prepare stmt;
-- call ap_debog('apres exec sql dyn');
--					select count(*) into v_nb_id,case isnull(min(ind)) when 1 then 0 else min(ind) end into v_min_ind,case isnull(max(ind)) when 1 then -1 else max(ind) end into v_max_ind from temp_tab_id;
--				select count(*),case isnull(min(ind)) when 1 then 0 else min(ind) end,case isnull(max(ind)) when 1 then -1 else max(ind) end into v_max_ind,v_min_ind,v_nb_id from temp_tab_id;
					select count(*) into v_nb_id from temp_tab_id where niveau=p_niveau;
					if(v_debog=1) then
						call ap_debog(concat('nb_id=',v_nb_id));
					end if;
					if(v_nb_id>0) then
-- print 'min_ind='+convert(varchar,@min_ind)+', max_ind='+convert(varchar,@max_ind)
--				if (v_nb_id=0) then
--					drop table temp_tab_id;
--				else
						select min(ind) into v_min_ind from temp_tab_id where niveau=p_niveau;
						select max(ind) into v_max_ind from temp_tab_id where niveau=p_niveau;
						if(v_debog=1) then
							call ap_debog(concat('v_min_ind=',v_min_ind,', v_max_ind=',v_max_ind));
						end if;
--					while (v_j<=v_max_ind) do
--						select id intov_id2 from temp_tab_id where ind=v_j;
-- print 'premeire boucle: j='+convert(varchar,@j)+', id2='+convert(varchar,@id2)
--						insert into v_tab_id(ind,id) values (v_j,v_id2);
--						set v_j=v_j+1;
--					end while;
-- print 'avant drop'
--					drop table temp_tab_id;
-- print 'apres drop'
--						select @j=@min_ind
--						while (@j<=@max_ind)
--						begin
--							select @id2=id from @tab_id where ind=@j
-- print 'deuxieme boucle: j='+convert(varchar,@j)+', id2='+convert(varchar,@id2)
--							select @j=@j+1
--						end
						set v_j=v_min_ind;
						while (v_j<=v_max_ind) do
-- select @num_instr=10
							select id into v_id2 from temp_tab_id where ind=v_j;
-- call ap_debog(concat('v_j=',v_j,', v_id2=',v_id2));
-- print 'j='+convert(varchar,@j)+', id2='+convert(varchar,@id2)
							if (v_id2>0) then
-- select @num_instr=11
								select count(*) into v_nb_dep from temp_dep;
-- print 'nb_dep='+convert(varchar,@nb_dep)
-- call ap_debog(concat('v_nb_dep=',v_nb_dep));
								if (v_nb_dep < p_max_lignes) then
-- print 'appel pour id='+convert(varchar,@id2)
-- select @num_instr=12
									set v_niv2=p_niveau+1;
-- call ap_debog(concat('v_niv2=',v_niv2));
									if (v_niv2<32 and v_niv2<=p_profondeur) then -- Nombre d'imbrication dans T-sql doit être inférieure à 32
-- select @num_instr=13
-- select @val_erreur=@sens+'/'+@nom_tab2+'/'+convert(varchar,@id2)+'/'+convert(varchar,@niv2)+'/'+convert(varchar,@max_lignes)+'/'+convert(varchar,@profondeur)
										if(v_debog=1) then
											call ap_debog(concat('avant appel recursif(',p_sens,',',v_nom_tab2,',',v_id2,',',v_niv2,')'));
										end if;
										call lec_dep_recurs (p_sens,v_nom_tab2,v_id2,v_niv2,p_max_lignes,p_profondeur,v_retour_recurs);
										if(v_debog=1) then
											call ap_debog('apres appel recursif');
										end if;
-- select @val_erreur=''
-- select @num_instr=14
									end if;
								end if;
							end if;
-- select @num_instr=15
							set v_j=v_j+1;
-- select @num_instr=16
						end while;
					end if;
--				END TRY
--				BEGIN CATCH
--			select @msg_erreur=ERROR_MESSAGE()+'('+@sql+')('+convert(varchar,@num_instr)+')('+@val_erreur+')'
--					select count(*) into v_nb from INFORMATION_SCHEMA.TABLES where TABLE_NAME='#tab_id';
--					if (v_nb>0) then
--						drop table #tab_id;
--					end if;
--					set v_msg_erreur=concat(ERROR_MESSAGE(),'(',v_sql,')');
--					if (p_sens = 'B') then
--						insert into #dep (niv,nom_tab,id,info) values (p_niveau+1,v_nom_tab2,null,v_msg_erreur);
--					else
--						insert into #dep (niv,nom_tab,id,info) values (p_niveau+1,p_nom_tab,null,v_msg_erreur);
--				END CATCH
--				delete #tab_id
--				select @nb_id=0
					set v_i=v_i+1;
				end while;
			end if;
		end if;
	end if;
	set p_retour='OK';
-- print 'fin de lec_dep_recurs('+@sens+','+@nom_tab+','+convert(varchar,@id)+','+convert(varchar,@niveau)+','+convert(varchar,@profondeur)+')'
end; //
delimiter ;
