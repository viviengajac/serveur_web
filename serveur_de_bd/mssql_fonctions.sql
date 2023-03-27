/****** Object:  UserDefinedFunction [dbo].[fct_rep]    Script Date: 16/12/2020 11:30:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fct_rep](@nom_tab varchar(30),@id int)
returns varchar(500)
as
begin
	declare @rep varchar(500)
	if(@nom_tab='AZecr')
	begin
		select @rep=nom_ecr from AZecr where id_AZecr=@id
	end
	else if(@nom_tab='AZonglet')
	begin
		select @rep=entete from AZonglet where id_AZonglet=@id
	end
	else if(@nom_tab='AZtype_champ')
	begin
		select @rep=nom_type_champ from AZtype_champ where id_AZtype_champ=@id
	end
	else if(@nom_tab='cerem')
	begin
		select @rep=nom_cerem from cerem where id_cerem=@id
	end
	else if(@nom_tab='deg')
	begin
		select @rep=nom_deg from deg where id_deg=@id
	end
	else if(@nom_tab='etat_prs')
	begin
		select @rep=nom_etat_prs from etat_prs where id_etat_prs=@id
	end
	else if(@nom_tab='loge')
	begin
		select @rep=nom_loge from loge where id_loge=@id
	end
	else if(@nom_tab='loge_tenue')
	begin
		select @rep=l.nom_loge+' '+convert(varchar,t.date_tenue,102) from loge_tenue t inner join loge l on t.id_loge=l.id_loge where id_loge_tenue=@id
	end
	else if(@nom_tab='obed')
	begin
		select @rep=nom_obed from obed where id_obed=@id
	end
	else if(@nom_tab='orient')
	begin
		select @rep=nom_orient from orient where id_orient=@id
	end
	else if(@nom_tab='prs')
	begin
		select @rep=nom_prs+' '+prenom_prs from prs where id_prs=@id
	end
	else if(@nom_tab='prs_doc')
	begin
		select @rep=t.nom_type_doc+isnull(': '+nom_doc,'') from prs_doc d inner join type_doc t on d.id_type_doc=t.id_type_doc where id_prs_doc=@id
	end
	else if(@nom_tab='prs_loge')
	begin
		select @rep=nom_loge+':'+nom_prs+' '+prenom_prs
			from prs_loge pl
			inner join prs p on pl.id_prs=p.id_prs
			inner join loge l on pl.id_loge=l.id_loge
			where id_prs_loge=@id
	end
	else if(@nom_tab='prs_off')
	begin
		select @rep=l.nom_loge+':'+t.type_off+': '+convert(varchar,d.date_tenue)+isnull('->'+convert(varchar,f.date_tenue),'')
			from prs_off o
			inner join type_off t on o.id_type_off=t.id_type_off
			inner join loge_tenue d on o.id_loge_tenue_deb=d.id_loge_tenue
			inner join loge l on d.id_loge=l.id_loge
			left outer join loge_tenue f on o.id_loge_tenue_fin=f.id_loge_tenue
			where id_prs_off=@id
	end
	else if(@nom_tab='prs_trv')
	begin
		select @rep=isnull(c.nom_cerem+' ','')+isnull(nom_trv,isnull(lib_tenue,'')) from prs_trv t
		inner join loge_tenue lt on t.id_loge_tenue=lt.id_loge_tenue
		left outer join cerem c on lt.id_cerem=c.id_cerem
		where id_prs_trv=@id;
	end
	else if(@nom_tab='rite')
	begin
		select @rep=nom_rite from rite where id_rite=@id
	end
	else if(@nom_tab='temple')
	begin
		select @rep=lib_temple from temple where id_temple=@id
	end
	else if(@nom_tab='tenue_date')
	begin
		select @rep=convert(varchar,t.date_tenue,102) from loge_tenue t where id_loge_tenue=@id
	end
	else if(@nom_tab='terr')
	begin
		select @rep=nom_terr from terr where id_terr=@id
	end
	else if(@nom_tab='type_doc')
	begin
		select @rep=nom_type_doc from type_doc where id_type_doc=@id
	end
	else if(@nom_tab='type_fic')
	begin
		select @rep=type_fic from type_fic where id_type_fic=@id
	end
	else if(@nom_tab='type_loge')
	begin
		select @rep=type_loge from type_loge where id_type_loge=@id
	end
	else if(@nom_tab='type_off')
	begin
		select @rep=type_off from type_off where id_type_off=@id
	end
	else if(@nom_tab='type_req_crit')
	begin
		select @rep=nom_type_req_crit from type_req_crit where id_type_req_crit=@id
	end
	else if(@nom_tab='type_tenue')
	begin
		select @rep=type_tenue from type_tenue where id_type_tenue=@id
	end
	else if (@nom_tab='ville')
	begin
		select @rep=nom_ville from ville where id_ville=@id
	end
	else
	begin
		select @rep=@nom_tab+': '+convert(varchar,@id)
	end
	return @rep
end
GO
/****** Object:  UserDefinedFunction [dbo].[fct_tenue_prs]    Script Date: 16/12/2020 11:30:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fct_tenue_prs](@id_loge_tenue int)
returns varchar(500)
as
begin
	declare @c_tenue_prs_ok int,
			@prs varchar(200),
			@liste_prs varchar(500)
	declare c_tenue_prs cursor for select p.nom_prs+' '+p.prenom_prs+isnull(' ('+t.nom_trv+')','') from prs p inner join prs_trv t on t.id_prs=p.id_prs where t.id_loge_tenue=@id_loge_tenue order by p.nom_prs,p.prenom_prs
	open c_tenue_prs
	select @c_tenue_prs_ok=1,@liste_prs=''
	while(@c_tenue_prs_ok=1)
	begin
		fetch c_tenue_prs into @prs
		if(@@fetch_status=0)
		begin
			if(len(@liste_prs)>0)
			begin
				select @liste_prs=@liste_prs+', '
			end
			select @liste_prs=@liste_prs+@prs
		end
		else
		begin
			select @c_tenue_prs_ok=0
		end
	end
	close c_tenue_prs
	deallocate c_tenue_prs
	return @liste_prs
end
GO
create function AZliste_colonnes_par_index(@obj_id int,@ind_id int)
returns varchar(500) as
begin
	declare @liste_cols varchar(500),
			@c_cols_ok int,
			@nom_col varchar(30)
	declare c_cols cursor for
		select c.name
		from sys.index_columns ic
		inner join sys.columns c on c.[object_id]=ic.[object_id] and c.column_id=ic.column_id
		where ic.[object_id]=@obj_id and ic.[index_id]=@ind_id
		order by ic.index_column_id
	open c_cols
	select @c_cols_ok=1,@liste_cols=''
	while(@c_cols_ok=1)
	begin
		fetch c_cols into @nom_col
		if(@@fetch_status=0)
		begin
			if(len(@liste_cols)>0)
			begin
				select @liste_cols=@liste_cols+', '
			end
			select @liste_cols=@liste_cols+@nom_col
		end
		else
		begin
			select @c_cols_ok=0
		end
	end
	close c_cols
	deallocate c_cols
	return @liste_cols
end
go