ALTER PROCEDURE [dbo].[lec_dep_recurs](@sens varchar(1),@nom_tab varchar(50),@id int,@niveau int,@max_lignes int,@profondeur int)
AS
begin
	declare	@niv2	int,
			@nb_cles	int,
			@nom_col	varchar(80),
			@nom_tab2	varchar(80),
			@nom_col2	varchar(80),
			@nom_pk		varchar(80),
			@i	int,
			@j	int,
			@id2	int,
			@nb_id	int,
			@sql	nvarchar(300),
			@nb_dep	int,
			@err	int,
			@faire	int,
			@num_instr int,
			@msg_erreur varchar(500),
			@val_erreur varchar(50),
			@ajout int,
			@min_ind int,
			@max_ind int,
			@ligne varchar(50),
			@nb int,
			@app_ds_dep bit
	declare @tab_cle table (ind int identity(1,1),nom_col varchar(80),nom_tab2 varchar(80),nom_col2 varchar(80),nom_pk varchar(80))
	declare @tab_id table (ind int,id int)
print 'debut de lec_dep_recurs('+@sens+','+@nom_tab+','+convert(varchar,@id)+','+convert(varchar,@niveau)+','+convert(varchar,@profondeur)+')'
--exec ap_debog @ligne
	if (@niveau > 0)
	begin
		select @nb=count(*) from #dep where nom_tab=@nom_tab and id=@id
		if (@nb = 0)
		begin
			insert into #dep (niv,nom_tab,id) values (@niveau,@nom_tab,@id)
			select @faire=1
		end
		else
		begin
			select @faire=0
		end
	end
	else
	begin
		select @faire=1
	end
print 'faire='+convert(varchar,@faire)
	select @niv2=@niveau+1
	if (@faire>0 and @niv2<32 and @niv2<=@profondeur)-- Nombre d'imbrication dans T-sql doit être inférieur a 32
	begin
print 'filtre passe'
		if (@sens = 'B')
		begin
			if (@nom_tab = 'prsaaa')
			begin
				select 0
			end
			else
			begin
				select @faire=1
--				declare lec_contr cursor for
--					select object_name(fkeyid),col_name(fkeyid,fkey),col_name(rkeyid,rkey),col_name(fkeyid,rkey)
--					from dbo.sysforeignkeys where object_name(rkeyid)=@nom_tab
			end
		end
		else
		begin
			select @faire=1
--			declare lec_contr cursor for
--				select object_name(rkeyid),col_name(rkeyid,rkey),col_name(fkeyid,fkey),col_name(rkeyid,rkey)
--				from dbo.sysforeignkeys where object_name(fkeyid)=@nom_tab
		end
		if (@faire>0)
		begin
			/*
			select @nb_cles=0
			open lec_contr
			fetch lec_contr into @nom_tab2,@nom_col2,@nom_col,@nom_pk
			while @@fetch_status = 0
			begin
				if (@sens = 'B')
				begin
					if (@nom_tab2 = 'detini_trace' and @nom_tab != 'detini_cab')
					begin
						select @faire=0
					end
					else
					begin
						select @faire=1
					end
				end
				else
				begin
					if (@nom_tab2 = 'detini_trace' and @nom_tab !='detini_cab')
					begin
						select @faire=0
					end
					else
					begin
						select @faire=1
					end
				end
--				select @faire=1
				if (@faire > 0)
				begin
-- print 'table('+convert(varchar,@nb_cles)+')='+@nom_col+','+@nom_tab2+','+@nom_col2
					insert into @tab_cle values (@nb_cles,@nom_col,@nom_tab2,@nom_col2,@nom_pk)
					select @nb_cles=@nb_cles+1
				end
				fetch lec_contr into @nom_tab2,@nom_col2,@nom_col,@nom_pk
			end
			close lec_contr
			deallocate lec_contr
			select @i=0
			while (@i<@nb_cles)
			*/
			if (@sens = 'B')
			begin
print 'sens vers le bas'
				insert into @tab_cle(nom_tab2,nom_col2,nom_col,nom_pk)
					select FK.TABLE_NAME,CU.COLUMN_NAME,CU2.COLUMN_NAME,CU3.COLUMN_NAME
					FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C
					INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK ON C.CONSTRAINT_NAME = FK.CONSTRAINT_NAME
					INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK ON C.UNIQUE_CONSTRAINT_NAME = PK.CONSTRAINT_NAME
					INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU ON C.CONSTRAINT_NAME = CU.CONSTRAINT_NAME
					INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK2 on PK2.TABLE_NAME=PK.TABLE_NAME and PK2.CONSTRAINT_TYPE='PRIMARY KEY'
					INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU2 on PK2.CONSTRAINT_NAME=CU2.CONSTRAINT_NAME
					INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK3 on PK3.TABLE_NAME=FK.TABLE_NAME and PK3.CONSTRAINT_TYPE='PRIMARY KEY'
					INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU3 on PK3.CONSTRAINT_NAME=CU3.CONSTRAINT_NAME
					where FK.CONSTRAINT_TYPE='FOREIGN KEY' and PK.TABLE_NAME = @nom_tab
					order by 1,2,3
--					select object_name(fkeyid),col_name(fkeyid,fkey),col_name(rkeyid,rkey),col_name(fkeyid,rkey)
--					from dbo.sysforeignkeys where object_name(rkeyid)=@nom_tab
			end
			else
			begin
				insert into @tab_cle(nom_tab2,nom_col2,nom_col,nom_pk)
					select CU.TABLE_NAME,CU.COLUMN_NAME,CU2.COLUMN_NAME,CU.COLUMN_NAME
					FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C
					INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK ON C.CONSTRAINT_NAME = FK.CONSTRAINT_NAME
					INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU2 ON FK.CONSTRAINT_NAME = CU2.CONSTRAINT_NAME
					INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK ON C.UNIQUE_CONSTRAINT_NAME = PK.CONSTRAINT_NAME
					INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU ON C.UNIQUE_CONSTRAINT_NAME = CU.CONSTRAINT_NAME
					where FK.CONSTRAINT_TYPE='FOREIGN KEY' and FK.TABLE_NAME = @nom_tab
					order by 1,2,3
--					select object_name(rkeyid),col_name(rkeyid,rkey),col_name(fkeyid,fkey),col_name(rkeyid,rkey)
--					from dbo.sysforeignkeys where object_name(fkeyid)=@nom_tab
			end
			select @nb_cles=max(ind) from @tab_cle
print 'apres insertion dans tab_cle: nb_cles='+convert(varchar,@nb_cles)
			select @i=1
			while (@i<=@nb_cles)
			begin
--				delete #tab_id
				select @nom_col=nom_col,@nom_tab2=nom_tab2,@nom_col2=nom_col2,@nom_pk=nom_pk from @tab_cle where ind=@i
print 'ind='+convert(varchar,@i)+', nom_col='+@nom_col+', nom_tab2='+@nom_tab2+', nom_col2='+@nom_col2+', nom_pk='+@nom_pk
				select @min_ind=0,@max_ind=0
				create table #tab_id (ind int identity (1,1),id int)
				if (@sens = 'B')
				begin
--						select @sql='declare lect_id cursor global for select '+@nom_pk+' from '+@nom_tab2+' where '+@nom_col2+'='+convert(varchar,@id)
--						select @sql='insert into @tab_id(id) select id_'+@nom_tab2+' from '+@nom_tab2+' where '+@nom_col2+'='+convert(varchar,@id)
					select @sql='insert into #tab_id(id) select '+@nom_pk+' from '+@nom_tab2+' where '+@nom_col2+'='+convert(varchar,@id)
				end
				else
				begin
--						select @sql='declare lect_id cursor global for select '+@nom_col+' from '+@nom_tab+' where id_'+@nom_tab+'='+convert(varchar,@id)
--						select @sql='insert into @tab_id(id) select '+@nom_col+' from '+@nom_tab+' where id_'+@nom_tab+'='+convert(varchar,@id)
					select @sql='insert into #tab_id(id) select '+@nom_col+' from '+@nom_tab+' where id_'+@nom_tab+'='+convert(varchar,@id)
				end
 print 'sql='+isnull(@sql,'sql')
				BEGIN TRY
--select @val_erreur=''
--select @num_instr=0
--					select @min_ind=isnull(min(ind),0) from #tab_id
					exec sp_executesql @sql
					/*
--select @num_instr=1
					open lect_id
--select @num_instr=2
					select @nb_id=0
					fetch lect_id into @id2
--select @num_instr=4
					while @@fetch_status = 0 and @nb_id < @max_lignes
					begin
	--print 'id lu='+convert(varchar,@id2)
--select @num_instr=5
						insert into @tab_id values (@nb_id,@id2)
--select @num_instr=6
						select @nb_id=@nb_id+1
--select @num_instr=7
						fetch lect_id into @id2
--select @num_instr=8
					end
					close lect_id
					deallocate lect_id
--select @num_instr=9
					select @nb_id=count(*) from @tab_id
					select @j=0
					while (@j<@nb_id)
					*/
					select @nb_id=count(*),@min_ind=isnull(min(ind),0),@max_ind=isnull(max(ind),-1) from #tab_id
 print 'min_ind='+convert(varchar,@min_ind)+', max_ind='+convert(varchar,@max_ind)
					if (@nb_id=0)
					begin
						drop table #tab_id
					end
					else
					begin
						select @j=@min_ind
						while (@j<=@max_ind)
						begin
							select @id2=id from #tab_id where ind=@j
-- print 'premeire boucle: j='+convert(varchar,@j)+', id2='+convert(varchar,@id2)
							insert into @tab_id(ind,id) values (@j,@id2)
							select @j=@j+1
						end
-- print 'avant drop'
						drop table #tab_id
-- print 'apres drop'
---						select @j=@min_ind
---						while (@j<=@max_ind)
---						begin
---							select @id2=id from @tab_id where ind=@j
-- print 'deuxieme boucle: j='+convert(varchar,@j)+', id2='+convert(varchar,@id2)
---							select @j=@j+1
---						end
						select @j=@min_ind
						while (@j<=@max_ind)
						begin
--select @num_instr=10
							select @id2=id from @tab_id where ind=@j
-- print 'j='+convert(varchar,@j)+', id2='+convert(varchar,@id2)
							if (@id2>0)
							begin
--select @num_instr=11
								select @nb_dep=count(*) from #dep
-- print 'nb_dep='+convert(varchar,@nb_dep)
								if (@nb_dep < @max_lignes)
								begin
-- print 'appel pour id='+convert(varchar,@id2)
--select @num_instr=12
									select @niv2=@niveau+1
									if (@niv2<32 and @niv2<=@profondeur)-- Nombre d'imbrication dans T-sql doit être inférieure à 32
									begin
-- select @num_instr=13
--select @val_erreur=@sens+'/'+@nom_tab2+'/'+convert(varchar,@id2)+'/'+convert(varchar,@niv2)+'/'+convert(varchar,@max_lignes)+'/'+convert(varchar,@profondeur)
										exec lec_dep_recurs @sens,@nom_tab2,@id2,@niv2,@max_lignes,@profondeur
--select @val_erreur=''
--select @num_instr=14
									end
								end
							end
--select @num_instr=15
							select @j=@j+1
--select @num_instr=16
						end
					end
				END TRY
				BEGIN CATCH
--			select @msg_erreur=ERROR_MESSAGE()+'('+@sql+')('+convert(varchar,@num_instr)+')('+@val_erreur+')'
					select @nb=count(*) from INFORMATION_SCHEMA.TABLES where TABLE_NAME='#tab_id'
					if (@nb>0)
					begin
						drop table #tab_id
					end
					select @msg_erreur=ERROR_MESSAGE()+'('+@sql+')'
					if (@sens = 'B')
						insert into #dep (niv,nom_tab,id,info) values (@niveau+1,@nom_tab2,null,@msg_erreur)
					else
						insert into #dep (niv,nom_tab,id,info) values (@niveau+1,@nom_tab,null,@msg_erreur)
				END CATCH
--				delete #tab_id
--				select @nb_id=0
				select @i=@i+1
			end
		end
	end
-- print 'fin de lec_dep_recurs('+@sens+','+@nom_tab+','+convert(varchar,@id)+','+convert(varchar,@niveau)+','+convert(varchar,@profondeur)+')'
end
