ALTER PROCEDURE [dbo].[lec_dependances](@sens varchar(1),@nom_tab varchar(50),@tab_id varchar(500),@max_lignes int,@profondeur int)
AS
begin
	set nocount on
	declare	@fini	int,
			@tab_id_tmp	varchar(500),
			@pos	int,
			@id		int,
			@tmp	varchar(500),
			@msmt bit
print 'lec_dependances('+@sens+','+@nom_tab+','+@tab_id+','+convert(varchar,@max_lignes)+','+convert(varchar,@profondeur)+')'
	select @pos=charindex(';',@tab_id)
	if (@pos = 0)
	begin
		select @tab_id=@tab_id+';'
	end
	create table #dep (id_dep int identity (1,1),niv int,nom_tab varchar(40),id int,info varchar(300))
--	create table #tab_id (ind int identity (1,1),id int)
	select @fini=0
	select @tab_id_tmp=@tab_id
	while (@fini = 0)
	begin
		select @pos=charindex(';',@tab_id_tmp)
print 'pos='+convert(varchar,@pos)
		if (@pos <= 0)
		begin
			select @fini=1
		end
		else
		begin
			if (@pos > 1)
			begin
				select @id=convert(int,substring(@tab_id_tmp,0,@pos))
print 'id='+convert(varchar,@id)
print 'profondeur='+convert(varchar,@profondeur)
				exec lec_dep_recurs @sens,@nom_tab,@id,0,@max_lignes,@profondeur
			end
			select @tmp=substring(@tab_id_tmp,@pos+1,999)
			select @tab_id_tmp=@tmp
		end
	end
--	select @msmt=msmt from prj
--	select id_dep,niv,nom_tab,isnull(sql,dbo.fct_rep_dependances(nom_tab,id,@msmt)) as rep,id from #dep order by id_dep
--	select id_dep,niv,nom_tab,dbo.fct_rep_dependances(nom_tab,id,@msmt) as rep,id from #dep order by id_dep
	select id_dep,niv,nom_tab,dbo.fct_rep(nom_tab,id) as rep,id from #dep order by id_dep
end
