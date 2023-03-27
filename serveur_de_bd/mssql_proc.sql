alter procedure [dbo].[ap_debog] @msg varchar(500)
as
set nocount on
insert into debog values (getdate(),@msg)
GO
alter procedure [dbo].[AZAZecr__AZchamp_critSelect] @id_AZecr int
as
set nocount on
	select '' as etat,cc.id_AZchamp_crit,cc.num_champ,c.id_AZtype_champ,tc.nom_type_champ as id_AZtype_champWITH,c.entete,c.nom_champ,c.lg_champ,
		c.lg_champ_ecr,c.maj,c.visible,c.dans_grille,c.cbo_nom_tab_ref,c.cbo_req,c.cbo_filtre_lib,c.cbo_filtre_id,cc.clause_sql
	 from AZchamp_crit cc
	 inner join AZchamp c on cc.id_AZchamp=c.id_AZchamp
	 inner join AZtype_champ tc on c.id_AZtype_champ=tc.id_AZtype_champ
	  where id_AZecr=@id_AZecr
	   order by cc.num_champ
GO
alter procedure [dbo].[AZAZecr__AZchamp_ongletSelect] @id_AZecr int
as
set nocount on
	select '' as etat,cc.id_AZchamp_onglet,o.id_AZonglet,o.entete as id_AZongletWITH,cc.num_champ,c.id_AZtype_champ,tc.nom_type_champ as id_AZtype_champWITH,c.entete,c.nom_champ,c.lg_champ,
		c.lg_champ_ecr,c.maj,c.visible,c.dans_grille,c.cbo_nom_tab_ref,c.cbo_req,c.cbo_filtre_lib,c.cbo_filtre_id
	 from AZchamp_onglet cc
	 inner join AZonglet o on cc.id_AZonglet=o.id_AZonglet
	 inner join AZchamp c on cc.id_AZchamp=c.id_AZchamp
	 inner join AZtype_champ tc on c.id_AZtype_champ=tc.id_AZtype_champ
	  where id_AZecr=@id_AZecr
	   order by o.num_onglet,cc.num_champ
GO
alter procedure [dbo].[AZAZecr__AZchamp_rechSelect] @id_AZecr int
as
set nocount on
	select '' as etat,cc.id_AZchamp_rech,cc.num_champ,c.id_AZtype_champ,tc.nom_type_champ as id_AZtype_champWITH,c.entete,c.nom_champ,c.lg_champ,
		c.lg_champ_ecr,c.maj,c.visible,c.dans_grille,c.cbo_nom_tab_ref,c.cbo_req,c.cbo_filtre_lib,c.cbo_filtre_id
	 from AZchamp_rech cc
	 inner join AZchamp c on cc.id_AZchamp=c.id_AZchamp
	 inner join AZtype_champ tc on c.id_AZtype_champ=tc.id_AZtype_champ
	  where id_AZecr=@id_AZecr
	   order by cc.num_champ
GO
alter procedure [dbo].[AZAZecr__recherche] @bidon int,@nom_ecr varchar(32)=null,@lib_ecr varchar(80)=null
as
set nocount on
	select top 200 count(*) over() as nb_lig,e.id_AZecr,e.nom_ecr as Nom,e.lib_ecr as Libellé
	 FROM AZecr e
	  where 1=1
	    ORDER BY nom_ecr
GO
alter procedure [dbo].[AZAZecrSelect] @id_AZecr int
as
set nocount on
select '' as etat,id_AZecr,nom_ecr,lib_ecr from AZecr where id_AZecr=@id_AZecr
GO
alter procedure [dbo].[AZceremMaj] @action char,@id_cerem int,@nom_cerem varchar(50),@lib_cerem varchar(80)
as
begin
set nocount on
	if (@action = 'U')
	begin
		update cerem set nom_cerem=@nom_cerem,lib_cerem=@lib_cerem where id_cerem=@id_cerem
	end
	else if (@action = 'I')
	begin
		insert into cerem (nom_cerem,lib_cerem) values (@nom_cerem,@lib_cerem)
	end
	else if (@action = 'D')
	begin
		delete from cerem where id_cerem=@id_cerem
	end
end
GO
alter procedure [dbo].[AZceremSelect]
as
set nocount on
select '' as etat,id_cerem,nom_cerem,lib_cerem from cerem order by nom_cerem
GO
alter procedure [dbo].[AZchamp_critCreer] @id_AZecr int,@num_champ int,@id_AZchamp int,@clause_sql varchar(80)
as
set nocount on
	DECLARE @idtech uniqueidentifier,
			@idcurrent int,
			@idnew int,
			@nom_tab varchar(30)
	select @nom_tab='AZchamp_crit'
	SET @idcurrent = IDENT_CURRENT(@nom_tab)
	SET @idtech = newid()
	insert into AZchamp_crit(id_AZecr,num_champ,id_AZchamp,clause_sql,IdTech)
		values (@id_AZecr,@num_champ,@id_AZchamp,@clause_sql,@idtech)
	SET @idnew = IDENT_CURRENT(@nom_tab) 
	if @idnew <> @idcurrent +1
	BEGIN
		SELECT @idnew = id_AZchamp_crit from AZchamp_crit where IdTech = @idtech
	END
	RETURN @idnew
GO
alter procedure [dbo].[AZchamp_ongletCreer] @id_AZonglet int,@num_champ int,@id_AZchamp int
as
set nocount on
	DECLARE @idtech uniqueidentifier,
			@idcurrent int,
			@idnew int,
			@nom_tab varchar(30)
	select @nom_tab='AZchamp_onglet'
	SET @idcurrent = IDENT_CURRENT(@nom_tab)
	SET @idtech = newid()
	insert into AZchamp_onglet(id_AZonglet,num_champ,id_AZchamp,IdTech)
		values (@id_AZonglet,@num_champ,@id_AZchamp,@idtech)
	SET @idnew = IDENT_CURRENT(@nom_tab) 
	if @idnew <> @idcurrent +1
	BEGIN
		SELECT @idnew = id_AZchamp_onglet from AZchamp_onglet where IdTech = @idtech
	END
	RETURN @idnew
GO
alter procedure [dbo].[AZchamp_rechCreer] @id_AZecr int,@num_champ int,@id_AZchamp int
as
set nocount on
	DECLARE @idtech uniqueidentifier,
			@idcurrent int,
			@idnew int,
			@nom_tab varchar(30)
	select @nom_tab='AZchamp_rech'
	SET @idcurrent = IDENT_CURRENT(@nom_tab)
	SET @idtech = newid()
	insert into AZchamp_rech(id_AZecr,num_champ,id_AZchamp,IdTech)
		values (@id_AZecr,@num_champ,@id_AZchamp,@idtech)
	SET @idnew = IDENT_CURRENT(@nom_tab) 
	if @idnew <> @idcurrent +1
	BEGIN
		SELECT @idnew = id_AZchamp_rech from AZchamp_rech where IdTech = @idtech
	END
	RETURN @idnew
GO
alter procedure [dbo].[AZchampCreer] @id_AZtype_champ int,@entete varchar(80),@nom_champ varchar(80),@lg_champ int,@lg_chanp_ecr int,@maj bit,@oblig bit,@visible bit,@cbo_nom_tab_ref varchar(80),@cbo_req varchar(200),@cbo_filtre_lib varchar(80),@cbo_filtre_id varchar(80)
as
set nocount on
	DECLARE @idtech uniqueidentifier,
			@idcurrent int,
			@idnew int,
			@nom_tab varchar(30)
	select @nom_tab='AZchamp'
	SET @idcurrent = IDENT_CURRENT(@nom_tab)
	SET @idtech = newid()
	insert into AZchamp(id_AZtype_champ,entete,nom_champ,lg_champ,lg_champ_ecr,maj,visible,cbo_nom_tab_ref,cbo_req,cbo_filtre_lib,cbo_filtre_id,oblig,IdTech)
		values (@id_AZtype_champ,@entete,@nom_champ,@lg_champ,@lg_chanp_ecr,@maj,@visible,@cbo_nom_tab_ref,@cbo_req,@cbo_filtre_lib,@cbo_filtre_id,@oblig,@idtech)
	SET @idnew = IDENT_CURRENT(@nom_tab) 
	if @idnew <> @idcurrent +1
	BEGIN
		SELECT @idnew = id_AZchamp from AZchamp where IdTech = @idtech		
	END
	select @idnew
GO

alter procedure [dbo].[AZchanger_mdp] @id_prs int,@cle varchar(200) as
begin
set nocount on
	update prs set cle=@cle where id_prs=@id_prs
	select 'OK'
end
GO
alter procedure [dbo].[AZdegMaj] @action char,@id_deg int,@nom_deg varchar(50),@lib_deg varchar(80),@code_deg varchar(5),@num_deg int
as
set nocount on
	if (@action ='U')
	begin
		update deg set nom_deg=@nom_deg,lib_deg=@lib_deg,code_deg=@code_deg,num_deg=@num_deg where id_deg=@id_deg
	end
	else if (@action = 'I')
	begin
		insert into deg (nom_deg,lib_deg,code_deg,num_deg) values (@nom_deg,@lib_deg,@code_deg,@num_deg)
	end
	else if (@action = 'D')
	begin
		delete from deg where id_deg=@id_deg
	end
GO
alter procedure [dbo].[AZdegSelect]
as
set nocount on
select '' as etat,id_deg,nom_deg,lib_deg,code_deg,num_deg from deg order by num_deg
GO
alter procedure [dbo].[AZecrMenage] @nom_ecr varchar(32)
as
set nocount on
	declare @tab_id_AZchamp_a_detruire table(id_AZchamp int)
	declare @id_AZecr int,
			@nb int
	select @nb=count(*) from AZecr where nom_ecr=@nom_ecr
	if(@nb>0)
	begin
		select @id_AZecr=id_AZecr from AZecr where nom_ecr=@nom_ecr
print 'id_AZecr='+convert(varchar,@id_AZecr)
		insert into @tab_id_AZchamp_a_detruire
			select id_AZchamp from AZchamp_crit where id_AZecr=@id_AZecr
			union
			select id_AZchamp from AZchamp_rech where id_AZecr=@id_AZecr
			union
			select id_AZchamp from AZchamp_onglet where id_AZonglet in (select id_AZonglet from AZonglet where id_AZecr=@id_AZecr)
		select @nb=count(*) from @tab_id_AZchamp_a_detruire
print '1: nb champs a detruire='+convert(varchar,@nb)
		delete AZchamp_crit where id_AZecr=@id_AZecr
print '2'
		delete AZchamp_rech where id_AZecr=@id_AZecr
print '3'
		delete AZchamp_onglet where id_AZonglet in (select id_AZonglet from AZonglet where id_AZecr=@id_AZecr)
print '4'
--		delete AZchamp where id_AZchamp not in (select id_AZchamp from AZchamp_crit union all select id_AZchamp from AZchamp_rech union all select id_AZchamp from AZchamp_onglet)
		delete AZchamp where id_AZchamp in (select id_AZchamp from @tab_id_AZchamp_a_detruire)
print '5'
		delete AZonglet where id_AZecr=@id_AZecr
print '6'
		delete AZtab where id_AZecr=@id_AZecr
print '7'
		delete AZecr where id_AZecr=@id_AZecr
print '8'
		select @id_AZecr
	end
	/*
	else
	begin
		insert into AZecr(nom_ecr) values (@nom_ecr)
		select id_AZecr from AZecr where nom_ecr=@nom_ecr
	end
	*/
GO
alter procedure [dbo].[AZetat_prsMaj] @action char,@id_etat_prs int,@nom_etat_prs varchar(50),@actif bit
as
set nocount on
	if (@action ='U')
	begin
		update etat_prs set nom_etat_prs=@nom_etat_prs,actif=@actif where id_etat_prs=@id_etat_prs
	end
	else if (@action = 'I')
	begin
		insert into etat_prs (nom_etat_prs,actif) values (@nom_etat_prs,@actif)
	end
	else if (@action = 'D')
	begin
		delete from etat_prs where id_etat_prs=@id_etat_prs
	end
GO
alter procedure [dbo].[AZetat_prsSelect]
as
select '' as etat,id_etat_prs,nom_etat_prs,actif from etat_prs order by nom_etat_prs
GO
alter procedure [dbo].[AZloge__liste_tenues]
as
set nocount on
	select t.id_loge_tenue,concat(substring(convert(nvarchar,t.date_tenue,103),1,10),IsNull(concat(' (',c.nom_cerem,')'),''))
	from loge_tenue t
	left outer join cerem c on t.id_cerem=c.id_cerem
	where 1=1
	order by t.date_tenue
GO
alter procedure [dbo].[AZloge__loge_docMaj] @etat char,@id_loge_doc int,@id_loge int,@nom_doc nvarchar(30),@lib_doc nvarchar(80),@date_doc datetime,@id_type_doc int,@id_type_fic int=null
as
set nocount on
	if (@etat ='U')
	begin
		update loge_doc set nom_doc=@nom_doc,lib_doc=@lib_doc,date_doc=@date_doc,id_type_doc=@id_type_doc,id_type_fic=@id_type_fic
		where id_loge_doc=@id_loge_doc
	end
	else if (@etat = 'I')
	begin
		insert into loge_doc (id_loge,nom_doc,lib_doc,date_doc,id_type_doc,id_type_fic) values (@id_loge,@nom_doc,@lib_doc,@date_doc,@id_type_doc,@id_type_fic)
--		insert into loge_doc (id_loge,nom_doc,lib_doc,date_doc,id_type_doc) values (@id_loge,@nom_doc,@lib_doc,@date_doc,@id_type_doc)
	end
	else if (@etat = 'D')
	begin
		delete from loge_doc where id_loge_doc=@id_loge_doc
	end
GO
alter procedure [dbo].[AZloge__loge_docSelect] @id_loge int
as
set nocount on
--select row_number() over(order by convert(varchar,po.date_deb,120)) as N,convert(varchar,po.date_deb,120) as Début,convert(varchar,po.date_fin,120) as Fin,tof.type_off as Office,l.nom_loge as Loge
select '' as etat,d.id_loge_doc,d.id_loge,d.nom_doc,d.lib_doc,d.date_doc,d.id_type_doc,t.nom_type_doc as id_type_docWITH,d.id_type_fic,tf.type_fic as id_type_ficWITH,len(doc_db) as voir_doc_db,d.id_loge_doc as def_doc_db,doc_fs as voir_doc_fs,d.id_loge_doc as def_doc_fs,d.id_type_fic
 from loge_doc d
 left outer join type_doc t on d.id_type_doc=t.id_type_doc
 left outer join type_fic tf on d.id_type_fic=tf.id_type_fic
 where d.id_loge=@id_loge
 order by t.num_doc,d.nom_doc
GO
alter procedure [dbo].[AZloge__loge_tenueMaj] @etat char,@id_loge_tenue int=0,@id_loge int=0,@id_type_tenue int=0,@date_tenue date=null,@id_cerem int=null,@lib_tenue varchar(100)=null
as
set nocount on
	if (@etat ='U')
	begin
		update loge_tenue set id_type_tenue=@id_type_tenue,date_tenue=@date_tenue,id_cerem=@id_cerem,lib_tenue=@lib_tenue where id_loge_tenue=@id_loge_tenue
	end
	else if (@etat = 'I')
	begin
		insert into loge_tenue (id_loge,id_type_tenue,date_tenue,id_cerem,lib_tenue) values (@id_loge,@id_type_tenue,@date_tenue,@id_cerem,@lib_tenue)
	end
	else if (@etat = 'D')
	begin
		delete from loge_tenue where id_loge_tenue=@id_loge_tenue
	end
GO
alter procedure [dbo].[AZloge__loge_tenueSelect] @id_loge int
as
set nocount on
--select row_number() over(order by convert(varchar,t.date_tenue,120)) as N,convert(varchar,t.date_tenue,120) as Date,tt.type_tenue as Forme,t.lib_tenue as Sujet
select '' as etat,t.id_loge_tenue,t.id_loge,t.id_type_tenue,tt.type_tenue as id_type_tenueWITH,t.date_tenue,t.id_cerem,c.nom_cerem as id_ceremWITH,t.lib_tenue,dbo.fct_tenue_prs(t.id_loge_tenue) as liste_prs
 from loge_tenue t
 inner join type_tenue tt on t.id_type_tenue=tt.id_type_tenue
 left outer join cerem c on t.id_cerem=c.id_cerem
 where t.id_loge=@id_loge
 order by t.date_tenue
GO
alter procedure [dbo].[AZloge__logeMaj] @etat char,@id_loge int,@nom_loge varchar(50),@id_obed int,@id_orient int,@id_type_loge int,@num_loge int,@id_rite int,@id_terr int,@id_temple int,@num_rna varchar(15)
as
set nocount on
	if (@etat ='U')
	begin
		update loge set nom_loge=@nom_loge,id_orient=@id_orient,id_obed=@id_obed,id_type_loge=@id_type_loge,num_loge=@num_loge,id_rite=@id_rite,id_terr=@id_terr,id_temple=@id_temple,num_rna=@num_rna where id_loge=@id_loge
	end
	else if (@etat = 'I')
	begin
		insert into loge (nom_loge,id_orient,id_obed,id_type_loge,num_loge,id_rite,id_terr,id_temple,num_rna) values (@nom_loge,@id_orient,@id_obed,@id_type_loge,@num_loge,@id_rite,@id_terr,@id_temple,@num_rna)
	end
	else if (@etat = 'D')
	begin
		delete from loge where id_loge=@id_loge
	end
GO
alter procedure [dbo].[AZloge__logeSelect] @id_loge int
as
set nocount on
select '' as etat,l.id_loge,l.nom_loge,l.id_obed,o.nom_obed as id_obedWITH,l.id_orient,ot.nom_orient as id_orientWITH,l.id_type_loge,tl.type_loge as id_type_logeWITH,l.num_loge,l.id_rite,r.nom_rite as id_riteWITH,l.id_terr,t.nom_terr as id_terrWITH,l.id_temple,tp.lib_temple as id_templeWITH,num_rna
 from loge l
 inner join obed o on l.id_obed=o.id_obed
 inner join orient ot on l.id_orient=ot.id_orient
 inner join type_loge tl on l.id_type_loge=tl.id_type_loge
 left outer join rite r on l.id_rite=r.id_rite
 left outer join terr t on l.id_terr=t.id_terr
 left outer join temple tp on l.id_temple=tp.id_temple
  where id_loge=@id_loge
GO
alter procedure [dbo].[AZloge__prs_off__ancienSelect] @id_loge int
as
set nocount on
--select row_number() over(order by convert(varchar,po.date_deb,120),tof.type_off) as N,convert(varchar,po.date_deb,120) as Début,convert(varchar,po.date_fin,120) as Fin,tof.type_off as Office,p.nom_prs as Nom,p.prenom_prs as Prénom
select '?' as etat,po.id_prs_off as id_prs_off__ancien,po.id_loge,po.id_loge_tenue_deb,dbo.fct_rep('tenue_date',po.id_loge_tenue_deb) as id_loge_tenue_debWITH,po.id_loge_tenue_fin,dbo.fct_rep('tenue_date',po.id_loge_tenue_fin) as id_loge_tenue_finWITH,po.id_type_off,tof.type_off as id_type_offWITH,po.id_prs,dbo.fct_rep('prs',po.id_prs) as id_prsWITH
 from prs_off po
 inner join loge_tenue td on po.id_loge_tenue_deb=td.id_loge_tenue
 inner join type_off tof on po.id_type_off=tof.id_type_off
 where po.id_loge=@id_loge and po.id_loge_tenue_fin is not null
 order by td.date_tenue,tof.num_off
GO
alter procedure [dbo].[AZloge__prs_offSelect] @id_loge int
as
set nocount on
--select row_number() over(order by tof.id_type_off) as N,tof.type_off as Office,p.nom_prs as Nom,p.prenom_prs as Prénom
select '' as etat,po.id_prs_off,po.id_loge,po.id_type_off,tof.type_off as id_type_offWITH,po.id_prs,dbo.fct_rep('prs',po.id_prs) as id_prsWITH
 from prs_off po
 inner join type_off tof on po.id_type_off=tof.id_type_off
 where po.id_loge=@id_loge and po.id_loge_tenue_fin is null
 order by tof.num_off
GO

alter procedure [dbo].[AZloge__prsMaj] @etat char,@id_prs_loge int=0,@id_loge int=0,@id_prs int=0
as
set nocount on
	declare @nb int
	if (@etat ='U')
	begin
		update prs_loge set id_prs=@id_prs,id_loge=@id_loge where id_prs_loge=@id_prs_loge
	end
	else if (@etat = 'I')
	begin
		select @nb=count(*) from prs where id_prs=@id_prs and id_loge=@id_loge
		if(@nb=0)
		begin
			insert into prs_loge (id_loge,id_prs) values (@id_loge,@id_prs)
		end
	end
	else if (@etat = 'D')
	begin
		delete from prs_loge where id_prs_loge=@id_prs_loge
	end
GO
alter procedure [dbo].[AZloge__prsSelect] @id_loge int
as
--select row_number() over(order by nom_prs,prenom_prs) as N,Nom_prs as Nom,prenom_prs as Prénom
set nocount on
select * from (
	select '' as etat,0 as id_prs_loge,id_loge,id_prs,dbo.fct_rep('prs',id_prs) as id_prsWITH
		from prs
		where id_loge=@id_loge and id_etat_prs=1
	union
	select '' as etat,pl.id_prs_loge,pl.id_loge,p.id_prs,dbo.fct_rep('prs',pl.id_prs) as id_prsWITH
		from prs_loge pl
		inner join prs p on pl.id_prs=p.id_prs
		where pl.id_loge=@id_loge and id_etat_prs=1
	) a
	order by id_prsWITH
GO
alter procedure [dbo].[AZloge__recherche] @id_prs_login int,@nom_loge varchar(50)=null,@id_obed int=null,@id_orient int=null,@num_loge int=null,@id_type_loge int=null
as
set nocount on
	select top 200 count(*) over() as nb_lig,l.id_loge,l.nom_loge,l.id_obed,o.nom_obed as id_obedWITH,l.id_orient,orient.nom_orient as id_orientWITH,num_loge as Numéro,l.id_type_loge,tl.lib_type_loge as id_type_logeWITH
	 FROM loge l
	 inner join obed o on l.id_obed=o.id_obed
	 inner join orient on l.id_orient=orient.id_orient
	 inner join type_loge tl on l.id_type_loge=tl.id_type_loge
	 inner join prs p on p.id_prs=@id_prs_login
	  where 1=1
	  and (l.nom_loge like @nom_loge or @nom_loge is null)
	   and (l.id_obed=@id_obed or @id_obed is null)
	    and (l.id_orient=@id_orient or @id_orient is null)
		and (l.num_loge=@num_loge or @num_loge is null)
		 and (l.id_type_loge=@id_type_loge or @id_type_loge is null)
		and (p.id_loge=l.id_loge or p.nivo_lec>1)
	    ORDER BY nom_loge
GO
alter procedure [dbo].[AZmaj_champ]
as
set nocount on
update AZecr set nom_ecr='Loges',lib_ecr='Loges' where nom_ecr='loge'
update AZecr set nom_ecr='Membres',lib_ecr='Membres' where nom_ecr='prs'
update AZchamp set entete='Membres' where nom_champ='liste_prs'
update AZchamp
	set cbo_req='select @top id_tenue as @id,dbo.fct_rep(''tenue_date'',id_tenue) as @lib from tenue where 1=1 order by 2',
		cbo_filtre_lib=' and dbo.fct_rep(''tenue_date'',id_tenue) like ''@valeur'''
		where nom_champ in ('id_tenue_deb','id_tenue_fin','id_tenue')
		and id_AZtype_champ in (select id_AZtype_champ from AZtype_champ where nom_type_champ='Combobox')
update AZonglet set entete='Loge' where nom_table='loge'
update AZonglet set entete='Documents' where nom_table='loge_doc'
update AZonglet set entete='Membres' where nom_table='prs' and id_AZtype_onglet in (select id_AZtype_onglet from AZtype_onglet where nom_type_onglet='Grille')
update AZonglet set entete='Détails' where nom_table='prs' and id_AZtype_onglet in (select id_AZtype_onglet from AZtype_onglet where nom_type_onglet='Formulaire')
update AZonglet set entete='Documents' where nom_table='prs_doc'
update AZonglet set entete='Offices' where nom_table='prs_off'
update AZonglet set entete='Offices anciens' where nom_table='prs_off__ancien'
update AZonglet set entete='Tenues' where nom_table='tenue'
update AZonglet set entete='Travaux' where nom_table='trv'
update AZchamp set maj=1 where id_AZchamp in (select id_AZchamp from AZchamp_onglet where id_AZonglet=(select id_AZonglet from AZonglet where nom_table='trv')) and nom_champ='id_loge'
update AZchamp set maj=1,nom_champ='actif',id_AZtype_champ=(select id_AZtype_champ from AZtype_champ where nom_type_champ='Booleen') where nom_champ='id_etat_prs' and id_AZchamp in (select id_AZchamp from AZchamp_crit where id_AZecr=(select id_AZecr from AZecr where nom_ecr='Membres'))
GO
alter procedure [dbo].[AZobedMaj] @action char,@id_obed int,@nom_obed varchar(50),@lib_obed varchar(80)
as
set nocount on
	if (@action ='U')
	begin
		update obed set nom_obed=@nom_obed,lib_obed=@lib_obed where id_obed=@id_obed
	end
	else if (@action = 'I')
	begin
		insert into obed (nom_obed,lib_obed) values (@nom_obed,@lib_obed)
	end
	else if (@action = 'D')
	begin
		delete from obed where id_obed=@id_obed
	end
GO
alter procedure [dbo].[AZobedSelect]
as
set nocount on
select '' as etat,id_obed,nom_obed,lib_obed from obed order by nom_obed
GO
alter procedure [dbo].[AZongletCreer] @id_AZecr int,@id_AZtype_onglet int, @num_onglet int,@entete varchar(80),@nom_table varchar(80),@req_lire varchar(255),@req_maj varchar(255),@proc_maj varchar(30)
as
set nocount on
	DECLARE @idtech uniqueidentifier,
			@idcurrent int,
			@idnew int,
			@nom_tab varchar(30)
	select @nom_tab='AZonglet'
	SET @idcurrent = IDENT_CURRENT(@nom_tab)
	SET @idtech = newid()
	insert into AZonglet(id_AZecr,id_AZtype_onglet,num_onglet,entete,nom_table,req_lire,req_maj,proc_maj,IdTech)
		values (@id_AZecr,@id_AZtype_onglet,@num_onglet,@entete,@nom_table,@req_lire,@req_maj,@proc_maj,@idtech)
	SET @idnew = IDENT_CURRENT(@nom_tab) 
	if @idnew <> @idcurrent +1
	BEGIN
		SELECT @idnew = id_AZonglet from AZonglet where IdTech = @idtech
	END
	select @idnew
GO
alter procedure [dbo].[AZorientMaj] @action char,@id_orient int,@nom_orient varchar(50)
as
set nocount on
	if (@action ='U')
	begin
		update orient set nom_orient=@nom_orient where id_orient=@id_orient
	end
	else if (@action = 'I')
	begin
		insert into orient (nom_orient) values (@nom_orient)
	end
	else if (@action = 'D')
	begin
		delete from orient where id_orient=@id_orient
	end
GO
alter procedure [dbo].[AZorientSelect]
as
set nocount on
select '' as etat,id_orient,nom_orient from orient order by nom_orient
GO
alter procedure [dbo].[AZprs__liste_tenues] @id_loge int,@id_loge_tenue_date_min int
as
set nocount on
	select t.id_loge_tenue,concat(substring(convert(nvarchar,t.date_tenue,103),1,10),IsNull(concat(' (',c.nom_cerem,')'),''))
	from loge_tenue t
	left outer join cerem c on t.id_cerem=c.id_cerem
	where 1=1
	and (t.id_loge=@id_loge or @id_loge=0)
	and (@id_loge_tenue_date_min=0 or t.date_tenue>(select date_tenue from loge_tenue where id_loge_tenue=@id_loge_tenue_date_min))
	order by t.date_tenue
GO
alter procedure [dbo].[AZprs__prs_docMaj] @etat char,@id_prs_doc int,@id_prs int,@nom_doc nvarchar(30),@lib_doc nvarchar(80),@date_doc datetime,@id_type_doc int --,@id_type_fic int
as
set nocount on
	if (@etat ='U')
	begin
		update prs_doc set nom_doc=@nom_doc,lib_doc=@lib_doc,date_doc=@date_doc,id_type_doc=@id_type_doc --,id_type_fic=@id_type_fic
		where id_prs_doc=@id_prs_doc
	end
	else if (@etat = 'I')
	begin
--		insert into prs_doc (id_prs,nom_doc,lib_doc,date_doc,id_type_doc,id_type_fic) values (@id_prs,@nom_doc,@lib_doc,@date_doc,@id_type_doc,@id_type_fic)
		insert into prs_doc (id_prs,nom_doc,lib_doc,date_doc,id_type_doc) values (@id_prs,@nom_doc,@lib_doc,@date_doc,@id_type_doc)
	end
	else if (@etat = 'D')
	begin
		delete from prs_doc where id_prs_doc=@id_prs_doc
	end
GO
alter procedure [dbo].[AZprs__prs_docSelect] @id_prs int
as
set nocount on
select '' as etat,d.id_prs_doc,d.id_prs,d.id_type_doc,t.nom_type_doc as id_type_docWITH,len(doc_db) as voir_doc_db,d.id_prs_doc as def_doc_db,doc_fs as voir_doc_fs,d.id_prs_doc as def_doc_fs,d.id_type_fic,tf.type_fic as id_type_ficWITH,d.nom_doc,d.lib_doc,d.date_doc
 from prs_doc d
left outer join type_doc t on d.id_type_doc=t.id_type_doc
left outer join type_fic tf on d.id_type_fic=tf.id_type_fic
 where d.id_prs=@id_prs
 order by t.num_doc,d.nom_doc
GO
alter procedure [dbo].[AZprs__prs_offMaj] @etat char,@id_prs_off int,@id_prs int,@id_loge int,@id_type_off int,@id_loge_tenue_deb int,@id_loge_tenue_fin int
as
set nocount on
	if (@etat ='U')
	begin
		update prs_off set id_loge=@id_loge,id_type_off=@id_type_off,id_loge_tenue_deb=@id_loge_tenue_deb,id_loge_tenue_fin=@id_loge_tenue_fin where id_prs_off=@id_prs_off
	end
	else if (@etat = 'I')
	begin
		insert into prs_off (id_prs,id_loge,id_type_off,id_loge_tenue_deb,id_loge_tenue_fin) values (@id_prs,@id_loge,@id_type_off,@id_loge_tenue_deb,@id_loge_tenue_fin)
	end
	else if (@etat = 'D')
	begin
		delete from prs_off where id_prs_off=@id_prs_off
	end
GO
alter procedure [dbo].[AZprs__prs_offSelect] @id_prs int
as
set nocount on
--select row_number() over(order by convert(varchar,po.date_deb,120)) as N,convert(varchar,po.date_deb,120) as Début,convert(varchar,po.date_fin,120) as Fin,tof.type_off as Office,l.nom_loge as Loge
select '' as etat,p.id_prs_off,p.id_prs,p.id_loge,l.nom_loge as id_logeWITH,p.id_type_off,o.type_off as id_type_offWITH,
	p.id_loge_tenue_deb,dbo.fct_rep('tenue_date',p.id_loge_tenue_deb) as id_loge_tenue_debWITH,
	p.id_loge_tenue_fin,dbo.fct_rep('tenue_date',p.id_loge_tenue_fin) as id_loge_tenue_finWITH
 from prs_off p
 inner join loge l on p.id_loge=l.id_loge
 inner join type_off o on p.id_type_off=o.id_type_off
 inner join loge_tenue td on p.id_loge_tenue_deb=td.id_loge_tenue
 where p.id_prs=@id_prs
 order by td.date_tenue,o.num_off
GO
alter procedure [dbo].[AZprs__prs_trvMaj] @etat char,@id_prs_trv int,@id_prs int,@id_loge_tenue int,@nom_trv varchar(100)
as
set nocount on
	if (@etat ='U' and @id_loge_tenue is not null)
	begin
		update prs_trv set id_loge_tenue=@id_loge_tenue,nom_trv=@nom_trv where id_prs_trv=@id_prs_trv
	end
	else if (@etat = 'I')
	begin
		insert into prs_trv (id_prs,id_loge_tenue,nom_trv) values (@id_prs,@id_loge_tenue,@nom_trv)
	end
	else if (@etat = 'D')
	begin
		delete from prs_trv where id_prs_trv=@id_prs_trv
	end
GO
alter procedure [dbo].[AZprs__prs_trvSelect] @id_prs int
as
set nocount on
--select row_number() over(order by convert(varchar,t.date_tenue,120)) as N,tt.type_tenue as Tenue,convert(varchar,t.date_tenue,120) as Date,isnull(trv.nom_trv,lib_tenue) as Sujet
--select trv.id_trv,'?' as etat_rang,trv.id_prs,t.id_tenue,tt.type_tenue,isnull(c.nom_cerem,t.lib_tenue) as lib_tenue,trv.nom_trv
select '' as etat,prs_trv.id_prs_trv,prs_trv.id_prs,t.id_loge,l.nom_loge as id_logeWITH,t.id_loge_tenue,dbo.fct_rep('tenue_date',t.id_loge_tenue) as id_loge_tenueWITH,dbo.fct_rep('type_tenue',id_type_tenue) as type_tenue,isnull(convert(varchar(100),dbo.fct_rep('cerem',id_cerem)),t.lib_tenue) as lib_tenue,prs_trv.nom_trv
	from prs_trv
	inner join loge_tenue t on prs_trv.id_loge_tenue=t.id_loge_tenue
	inner join loge l on t.id_loge=l.id_loge
	where prs_trv.id_prs=@id_prs
	order by convert(nvarchar,t.date_tenue,120)
GO
alter procedure [dbo].[AZprs__prsMaj] @etat char,@id_prs int,@nom_prs varchar(20),@prenom_prs varchar(20),@id_loge int,@ad1 varchar(80),@ad2 varchar(80),@id_ville int,@ad_elec varchar(80),@tel1 varchar(20),@tel2 varchar(20),@id_etat_prs int,@lieu_comp varchar(80),@nom_comp varchar(80),@info_prs varchar(500),@id_deg_bl int,@id_deg_av int,@date_naiss datetime,@lieu_naiss nvarchar(30),@nom_naiss nvarchar(30)
as
set nocount on
	if (@etat ='U')
	begin
		update prs set nom_prs=@nom_prs,prenom_prs=@prenom_prs,id_loge=@id_loge,ad1=@ad1,ad2=@ad2,id_ville=@id_ville,ad_elec=@ad_elec,tel1=@tel1,tel2=@tel2,id_etat_prs=@id_etat_prs,lieu_comp=@lieu_comp,nom_comp=@nom_comp,info_prs=@info_prs,id_deg_bl=@id_deg_bl,id_deg_av=@id_deg_av,date_naiss=@date_naiss,lieu_naiss=@lieu_naiss,nom_naiss=@nom_naiss where id_prs=@id_prs
	end
	else if (@etat = 'I')
	begin
		insert into prs (nom_prs,prenom_prs,id_loge,ad1,ad2,id_ville,ad_elec,tel1,tel2,id_etat_prs,lieu_comp,nom_comp,info_prs,id_deg_bl,id_deg_av,date_naiss,lieu_naiss,nom_naiss) values (@nom_prs,@prenom_prs,@id_loge,@ad1,@ad2,@id_ville,@ad_elec,@tel1,@tel2,1,@lieu_comp,@nom_comp,@info_prs,@id_deg_bl,@id_deg_av,@date_naiss,@lieu_naiss,@nom_naiss)
	end
	else if (@etat = 'D')
	begin
		delete from prs where id_prs=@id_prs
	end
GO
alter procedure [dbo].[AZprs__prsSelect] @id_prs int
as
set nocount on
select '?' as etat,p.id_prs,p.nom_prs,p.prenom_prs,p.id_loge,l.nom_loge as id_logeWITH,p.ad1,p.ad2,p.id_ville,v.nom_ville as id_villeWITH,p.ad_elec,p.tel1,p.tel2,p.id_etat_prs,e.nom_etat_prs as id_etat_prsWITH,p.lieu_comp,p.nom_comp,p.info_prs,p.id_deg_bl,deg_bl.nom_deg as id_deg_blWITH,p.id_deg_av,deg_av.nom_deg as id_deg_avWITH,p.date_naiss,p.lieu_naiss,p.nom_naiss,e.actif
 from prs p
 inner join loge l on p.id_loge=l.id_loge
 inner join ville v on p.id_ville=v.id_ville
 inner join etat_prs e on p.id_etat_prs=e.id_etat_prs
 inner join deg deg_bl on p.id_deg_bl=deg_bl.id_deg
 left outer join deg deg_av on p.id_deg_av=deg_av.id_deg
 where id_prs=@id_prs
GO
alter procedure [dbo].[AZprs__recherche] @id_prs_login int,@nom_prs varchar(20)=null,@prenom_prs varchar(20)=null,@id_loge int=null,@id_deg_bl int=null,@actif bit=1
as
set nocount on
--select row_number() over(order by convert(varchar,po.date_deb,120)) as N,convert(varchar,po.date_deb,120) as Début,convert(varchar,po.date_fin,120) as Fin,tof.type_off as Office,l.nom_loge as Loge
/*
	declare @sql varchar(2000)
	declare @critere varchar(2000)
	select @sql='select T.id_prs,T.nom_prs,T.prenom_prs,T.id_loge,l.nom_loge as id_logeWITH,T.id_deg_bl,d.nom_deg as id_deg_blWITH,T.ad_elec,T.id_etat_prs,e.etat_prs as id_etat_prsWITH'
	select @sql=@sql+'	 FROM prs T'
	select @sql=@sql+'  inner join loge l on T.id_loge=l.id_loge'
	select @sql=@sql+'   inner join deg d on T.id_deg_bl=d.id_deg'
	select @sql=@sql+'    inner join etat_prs e on T.id_etat_prs=e.id_etat_prs'
	select @sql=@sql+'	 WHERE 1=1 ORDER BY nom_prs,prenom_prs'
	if(@nom_prs is not null
	exec sp_executesql @sql
	*/
	declare @actif_bd bit
	if(@actif=1)
	begin
		select @actif_bd=1
	end
	else
	begin
		select @actif_bd=0
	end
	select top 200 count(*) over() as nb_lig,T.id_prs,T.nom_prs,T.prenom_prs,T.id_loge,l.nom_loge as id_logeWITH,T.id_deg_bl,d.nom_deg as id_deg_blWITH,T.ad_elec,T.id_etat_prs,e.nom_etat_prs as id_etat_prsWITH,e.actif
		 FROM prs T
		inner join loge l on T.id_loge=l.id_loge
		inner join deg d on T.id_deg_bl=d.id_deg
	    inner join etat_prs e on T.id_etat_prs=e.id_etat_prs
		inner join prs p on p.id_prs=@id_prs_login
		WHERE 1=1
			and (T.nom_prs like @nom_prs or @nom_prs is null)
			and (T.prenom_prs like @prenom_prs or @prenom_prs is null)
			and (T.id_loge=@id_loge or @id_loge is null)
			and (T.id_deg_bl=@id_deg_bl or @id_deg_bl is null)
			and (T.id_etat_prs in (select id_etat_prs from etat_prs where actif=@actif_bd) or @actif_bd=0)
			and (T.id_prs=p.id_prs or (p.nivo_lec=2 and T.id_loge=p.id_loge) or p.nivo_lec=3)
		ORDER BY nom_prs,prenom_prs
GO

alter procedure [dbo].[AZreq__recherche] @bidon int,@nom_req varchar(30)=null,@desc_req varchar(80)=null,@req_sql varchar(1000)=null,@nom_modele_excel varchar(30)=null,@nom_macro_excel varchar(30)=null,@temps_exec int=null
as
set nocount on
	select top 200 count(*) over() as nb_lig,r.id_req,r.nom_req,r.desc_req,r.req_sql,r.nom_modele_excel,r.nom_macro_excel,r.temps_exec
	 FROM req r
	  where 1=1
	  and (r.nom_req like @nom_req or @nom_req is null)
	   and (r.desc_req=@desc_req or @desc_req is null)
	    and (r.req_sql=@req_sql or @req_sql is null)
		and (r.nom_modele_excel=@nom_modele_excel or @nom_modele_excel is null)
		 and (r.nom_macro_excel=@nom_macro_excel or @nom_macro_excel is null)
		 and (r.temps_exec=@temps_exec or @temps_exec is null)
	    ORDER BY nom_req
GO

alter procedure [dbo].[AZreq__req_critSelect] @id_req int
as
set nocount on
--select row_number() over(order by convert(varchar,po.date_deb,120)) as N,convert(varchar,po.date_deb,120) as Début,convert(varchar,po.date_fin,120) as Fin,tof.type_off as Office,l.nom_loge as Loge
select '' as etat,c.id_req_crit,c.num_req_crit,c.nom_req_crit,c.desc_req_crit,c.id_type_req_crit,t.nom_type_req_crit as id_type_req_critWITH,c.nom_tab_si_combo,c.req_crit_sql
 from req_crit c
 inner join type_req_crit t on c.id_type_req_crit=t.id_type_req_crit
 where c.id_req=@id_req
 order by c.num_req_crit
GO
alter procedure [dbo].[AZreq_critMaj] @action char,@id_req_crit int,@id_req int,@num_req_crit int,@nom_req_crit varchar(80),@desc_req_crit varchar(80),@id_type_req_crit int,@req_sql_si_combo varchar(80),@req_crit_sql varchar(100)
as
set nocount on
	if (@action ='U')
	begin
		update req_crit set num_req_crit=@num_req_crit,nom_req_crit=@nom_req_crit,id_type_req_crit=@id_type_req_crit,req_sql_si_combo=@req_sql_si_combo,req_crit_sql=@req_crit_sql where id_req_crit=@id_req_crit
	end
	else if (@action = 'I')
	begin
		insert into req_crit (id_req,num_req_crit,nom_req_crit,id_type_req_crit,req_sql_si_combo,req_crit_sql) values (@id_req,@num_req_crit,@nom_req_crit,@id_type_req_crit,@req_sql_si_combo,@req_crit_sql)
	end
	else if (@action = 'D')
	begin
		delete from req_crit where id_req_crit=@id_req_crit
	end
GO
alter procedure [dbo].[AZreq_critSelect] @id_req int
as
set nocount on
--select row_number() over(order by convert(varchar,t.date_tenue,120)) as N,tt.type_tenue as Tenue,convert(varchar,t.date_tenue,120) as Date,isnull(trv.nom_trv,lib_tenue) as Sujet
--select trv.id_trv,'?' as etat_rang,trv.id_prs,t.id_tenue,tt.type_tenue,isnull(c.nom_cerem,t.lib_tenue) as lib_tenue,trv.nom_trv
select '' as etat,c.id_req_crit,c.id_req,c.num_req_crit,c.nom_req_crit,c.desc_req_crit,c.id_type_req_crit,c.req_sql_si_combo,c.req_crit_sql
	from req_crit c
	where c.id_req=@id_req
	order by c.num_req_crit
GO
alter procedure [dbo].[AZreqMaj] @action char,@id_req int,@nom_req varchar(20),@desc_req varchar(80),@req_sql varchar(1000),@nom_modele_excel varchar(30),@nom_macro_excel varchar(30),@temps_exec_excel int
as
set nocount on
	if (@action ='U')
	begin
		update req set nom_req=@nom_req,desc_req=@desc_req,req_sql=@req_sql,nom_modele_excel=@nom_modele_excel,nom_macro_excel=@nom_macro_excel,temps_exec_excel=@temps_exec_excel where id_req=@id_req
	end
	else if (@action = 'I')
	begin
		insert into req (nom_req,desc_req,req_sql,nom_modele_excel,nom_macro_excel,temps_exec_excel) values (@nom_req,@desc_req,@req_sql,@nom_modele_excel,@nom_macro_excel,@temps_exec_excel)
	end
	else if (@action = 'D')
	begin
		delete from req where id_req=@id_req
	end
GO
alter procedure [dbo].[AZreqSelect] @id_req int
as
set nocount on
select '' as etat,id_req,nom_req,desc_req,req_sql,nom_modele_excel,nom_macro_excel,temps_exec
 from req
 where id_req=@id_req
GO
alter procedure [dbo].[AZriteMaj] @action char,@id_rite int,@nom_rite varchar(50),@lib_rite varchar(80)
as
set nocount on
	if (@action ='U')
	begin
		update rite set nom_rite=@nom_rite,lib_rite=@lib_rite where id_rite=@id_rite
	end
	else if (@action = 'I')
	begin
		insert into rite (nom_rite,lib_rite) values (@nom_rite,@lib_rite)
	end
	else if (@action = 'D')
	begin
		delete from rite where id_rite=@id_rite
	end
GO
alter procedure [dbo].[AZriteSelect]
as
set nocount on
select '' as etat,id_rite,nom_rite,lib_rite from rite order by nom_rite
GO
alter procedure [dbo].[AZtempleMaj] @action char,@id_temple int,@code_temple varchar(20),@lib_temple varchar(80),@adr_temple varchar(80),@id_ville int
as
set nocount on
	if (@action ='U')
	begin
		update temple set code_temple=@code_temple,lib_temple=@lib_temple,adr_temple=@adr_temple,id_ville=@id_ville where id_temple=@id_temple
	end
	else if (@action = 'I')
	begin
		insert into temple (code_temple,lib_temple,adr_temple,id_ville) values (@code_temple,@lib_temple,@adr_temple,@id_ville)
	end
	else if (@action = 'D')
	begin
		delete from temple where id_temple=@id_temple
	end
GO
alter procedure [dbo].[AZtempleSelect]
as
set nocount on
select '' as etat,id_temple,code_temple,lib_temple,adr_temple,id_ville from temple order by code_temple
GO
alter procedure [dbo].[AZterrMaj] @action char,@id_terr int,@code_terr nvarchar(10),@nom_terr nvarchar(30)
as
set nocount on
	if (@action ='U')
	begin
		update terr set code_terr=@code_terr,nom_terr=@nom_terr where id_terr=@id_terr
	end
	else if (@action = 'I')
	begin
		insert into terr (code_terr,nom_terr) values (@code_terr,@nom_terr)
	end
	else if (@action = 'D')
	begin
		delete from terr where id_terr=@id_terr
	end
GO
alter procedure [dbo].[AZterrSelect]
as
set nocount on
select '' as etat,id_terr,code_terr,nom_terr from terr order by nom_terr
GO
alter procedure [dbo].[AZtype_docMaj] @action char,@id_type_doc int,@code_type_doc nvarchar(20),@nom_type_doc varchar(30),@lib_type_doc varchar(80),@num_doc int
as
set nocount on
	if (@action ='U')
	begin
		update type_doc set code_type_doc=@code_type_doc,nom_type_doc=@nom_type_doc,lib_type_doc=@lib_type_doc,num_doc=@num_doc where id_type_doc=@id_type_doc
	end
	else if (@action = 'I')
	begin
		insert into type_doc (code_type_doc,nom_type_doc,lib_type_doc,num_doc) values (@code_type_doc,@nom_type_doc,@lib_type_doc,@num_doc)
	end
	else if (@action = 'D')
	begin
		delete from type_doc where id_type_doc=@id_type_doc
	end
GO
alter procedure [dbo].[AZtype_docSelect]
as
set nocount on
select '' as etat,id_type_doc,code_type_doc,nom_type_doc,lib_type_doc,num_doc from type_doc order by nom_type_doc
GO
alter procedure [dbo].[AZtype_logeMaj] @action char,@id_type_loge int,@type_loge varchar(50),@lib_type_loge varchar(80)
as
set nocount on
	if (@action ='U')
	begin
		update type_loge set type_loge=@type_loge,lib_type_loge=@lib_type_loge where id_type_loge=@id_type_loge
	end
	else if (@action = 'I')
	begin
		insert into type_loge (type_loge,lib_type_loge) values (@type_loge,@lib_type_loge)
	end
	else if (@action = 'D')
	begin
		delete from type_loge where id_type_loge=@id_type_loge
	end
GO
alter procedure [dbo].[AZtype_logeSelect]
as
set nocount on
select '' as etat,id_type_loge,type_loge,lib_type_loge from type_loge order by type_loge
GO
alter procedure [dbo].[AZtype_offMaj] @action char,@id_type_off int,@type_off nvarchar(100),@num_off int,@id_deg int,@id_rite int
as
set nocount on
	if (@action ='U')
	begin
-- insert debog values (getdate(),'id_type_off=('+isnull(convert(varchar,@id_type_off),'?')+', type_off=('+@type_off+')')
		update type_off set type_off=@type_off,num_off=@num_off,id_deg=@id_deg,id_rite=@id_rite where id_type_off=@id_type_off
	end
	else if (@action = 'I')
	begin
		insert into type_off (type_off,num_off,id_deg,id_rite) values (@type_off,@num_off,@id_deg,@id_rite)
	end
	else if (@action = 'D')
	begin
		delete from type_off where id_type_off=@id_type_off
	end
GO
alter procedure [dbo].[AZtype_offSelect]
as
set nocount on
select '' as etat,id_type_off,type_off,num_off,id_deg,id_rite from type_off order by type_off
GO
alter procedure [dbo].[AZtype_tenueMaj] @action char,@id_type_tenue int,@type_tenue varchar(30),@lib_type_tenue varchar(80),@id_deg int
as
set nocount on
	if (@action ='U')
	begin
		update type_tenue set type_tenue=@type_tenue,lib_type_tenue=@lib_type_tenue,id_deg=@id_deg where id_type_tenue=@id_type_tenue
	end
	else if (@action = 'I')
	begin
		insert into type_tenue (type_tenue,lib_type_tenue,id_deg) values (@type_tenue,@lib_type_tenue,@id_deg)
	end
	else if (@action = 'D')
	begin
		delete from type_tenue where id_type_tenue=@id_type_tenue
	end
GO
alter procedure [dbo].[AZtype_tenueSelect]
as
set nocount on
select '' as etat,id_type_tenue,type_tenue,lib_type_tenue,id_deg from type_tenue order by type_tenue
GO

alter procedure [dbo].[AZvalider_prs] @id_prs int,@cle varchar(200) as
begin
set nocount on
	declare @nb int
	select @nb=count(*) from prs where id_prs=@id_prs and cle=@cle
--	select case @nb when 1 then 'OK' else 'KO' end
	select 'OK'
end
GO
alter procedure AZvalider_prs_mdp @id_prs int,@cle varchar(200)
as
begin
	declare @nb int;
	declare @ret varchar(20);
	declare @niv_lec int,
			@niv_ecr int,
			@niv_exp int
	select @nb=count(*) from prs where id_prs=@id_prs and mdp=@cle;
	if(@nb>0)
	begin
		select @ret=concat(isnull(nivo_lec,1),'|',isnull(nivo_ecr,1),'|',isnull(nivo_exp,1)) from prs where id_prs=@id_prs
	end
	else
	begin
		select @ret='-1|-1|-1'
	end
	select @ret;
end
go
alter procedure [dbo].[AZvilleMaj] @action char,@id_ville int,@nom_ville nvarchar(30),@code_postal nvarchar(10)
as
set nocount on
	if (@action ='U')
	begin
		update ville set nom_ville=@nom_ville,code_postal=@code_postal where id_ville=@id_ville
	end
	else if (@action = 'I')
	begin
		insert into ville (nom_ville,code_postal) values (@nom_ville,@code_postal)
	end
	else if (@action = 'D')
	begin
		delete from ville where id_ville=@id_ville
	end
GO
alter procedure [dbo].[AZvilleSelect]
as
set nocount on
select '' as etat,id_ville,nom_ville,code_postal from ville order by nom_ville
GO
alter procedure [dbo].[coll_off] @bidon int,@id_loge int=null as
begin
set nocount on
	select tof.type_off as Office,p.nom_prs as Nom,p.prenom_prs as Prénom
	from prs_off o
	inner join type_off tof on tof.id_type_off=o.id_type_off
	inner join prs p on o.id_prs=p.id_prs
	where o.id_tenue_fin is null and o.id_loge=@id_loge
	order by tof.num_off,p.nom_prs,p.prenom_prs
end
GO
alter procedure [dbo].[cursus] @bidon int,@id_prs int as
begin
set nocount on
	declare @id_initiation int,@id_enreg int,@id_cayenne int,@id_maitrise int,
		@nom_prs varchar(20),@prenom_prs varchar(20),@lieu_comp varchar(80),@nom_comp varchar(80),
		@id_loge_init int,@nb int,@nom_loge_init varchar(50),
		@date_initiation datetime,@date_enreg datetime,@date_cayenne datetime,@date_maitrise datetime
	select @id_initiation=id_cerem from cerem where nom_cerem='Initiation'
	select @id_enreg=id_cerem from cerem where nom_cerem='Enregistrement'
	select @id_cayenne=id_cerem from cerem where nom_cerem='Passage en Cayenne'
	select @id_maitrise=id_cerem from cerem where nom_cerem='Elévation à la maîtrise'
	select @nom_prs=p.nom_prs,@prenom_prs=p.prenom_prs,@lieu_comp=p.lieu_comp,@nom_comp=p.nom_comp
		from prs p where p.id_prs=@id_prs
	select @nb=count(*) from trv,tenue t
		where trv.id_prs=@id_prs and trv.id_tenue=t.id_tenue and t.id_cerem=@id_initiation
	if(@nb>0)
	begin
		select @date_initiation=t.date_tenue,@id_loge_init=t.id_loge from trv,tenue t
			where trv.id_prs=@id_prs and trv.id_tenue=t.id_tenue and t.id_cerem=@id_initiation
		select @nom_loge_init=nom_loge from loge where id_loge=@id_loge_init
	end
	select @nb=count(*) from trv,tenue t
		where trv.id_prs=@id_prs and trv.id_tenue=t.id_tenue and t.id_cerem=@id_enreg
	if(@nb>0)
	begin
		select @date_enreg=t.date_tenue from trv,tenue t
			where trv.id_prs=@id_prs and trv.id_tenue=t.id_tenue and t.id_cerem=@id_enreg
	end
	select @nb=count(*) from trv,tenue t
		where trv.id_prs=@id_prs and trv.id_tenue=t.id_tenue and t.id_cerem=@id_cayenne
	if(@nb>0)
	begin
		select @date_cayenne=t.date_tenue from trv,tenue t
			where trv.id_prs=@id_prs and trv.id_tenue=t.id_tenue and t.id_cerem=@id_cayenne
	end
	select @nb=count(*) from trv,tenue t
		where trv.id_prs=@id_prs and trv.id_tenue=t.id_tenue and t.id_cerem=@id_maitrise
	if(@nb>0)
	begin
		select @date_maitrise=t.date_tenue from trv,tenue t
			where trv.id_prs=@id_prs and trv.id_tenue=t.id_tenue and t.id_cerem=@id_maitrise
	end
	select @nom_prs as Nom,@prenom_prs as Prénom,
		@lieu_comp as Lieu__comp,@nom_comp as Nom__comp,
		@date_initiation as Initiation,
		@date_enreg as Enregistrement,
		@date_cayenne as Cayenne,
		@date_maitrise as Maitrise
end
GO
alter procedure [dbo].[effectifs] @bidon int,@id_loge int=null as
begin
set nocount on
	select l.nom_loge as Loge,p.nom_prs as Nom,p.prenom_prs as Prénom,d.nom_deg_bl as Degré
	from prs p
	inner join loge l on p.id_loge=l.id_loge
	inner join deg_bl d on p.id_deg_bl=d.id_deg_bl
	where p.id_loge=@id_loge or @id_loge is null and p.id_etat_prs=1
	order by l.nom_loge,p.nom_prs,p.prenom_prs
end
GO
alter procedure [dbo].[lister_references] as
begin
set nocount on
select * from deg_bl
select * from ville
end
GO
alter procedure [dbo].[manque_doc] @bidon int,@id_type_doc int=null as
begin
set nocount on
	select p.nom_prs,p.prenom_prs
	from prs p
	where p.id_etat_prs=1 and not exists
		(select d.id_prs_doc from prs_doc d where d.id_prs=p.id_prs and d.id_type_doc=@id_type_doc)
	order by p.nom_prs,p.prenom_prs
end
GO
alter procedure [dbo].[travaux] @bidon int,@id_loge int=null as
begin
set nocount on
	select d.nom_deg_bl,t.date_tenue,isnull(t.lib_tenue,'')+isnull(tr.nom_trv,'') as trv,p.nom_prs+' '+p.prenom_prs
	from trv tr
	inner join tenue t on tr.id_tenue=t.id_tenue
	inner join prs p on tr.id_prs=p.id_prs
	inner join loge l on t.id_loge=l.id_loge
	inner join type_tenue tt on t.id_type_tenue=tt.id_type_tenue
	inner join deg_bl d on tt.id_deg_bl=d.id_deg_bl
	where isnull(t.lib_tenue,'')+isnull(tr.nom_trv,'')!='' and (l.id_loge=@id_loge or @id_loge is null)
	order by d.nom_deg_bl,t.date_tenue,p.nom_prs,p.prenom_prs
end
GO
alter procedure AZlire_index as
begin
set nocount on
	select i.name
	from sys.indexes i
	where i.is_unique=1
end
go
alter procedure AZinit_cbo @nom_tab varchar(20) as
begin
	if (@nom_tab='cerem')
	begin
		select id_cerem,nom_cerem from cerem order by 2;
	end
	else if(@nom_tab='deg_bl')
	begin
		select id_deg,nom_deg from deg where avancement=0 order by 2
	end
	else if(@nom_tab='deg_av')
	begin
		select id_deg,nom_deg from deg where avancement=1 order by 2
	end
	else if(@nom_tab='etat_prs')
	begin
		select id_etat_prs,nom_etat_prs from etat_prs order by 2
	end
	else if(@nom_tab='loge')
	begin
		select id_loge,nom_loge from loge order by 2
	end
	else if(@nom_tab='loge_tenue')
	begin
		select id_loge_tenue,date_tenue from loge_tenue order by 2;
	end
	else if(@nom_tab='loge_tenue_deb')
	begin
		select id_loge_tenue,date_tenue from loge_tenue order by 2;
	end
	else if(@nom_tab='loge_tenue_fin')
	begin
		select id_loge_tenue,date_tenue from loge_tenue order by 2;
	end
	else if (@nom_tab='obed')
	begin
		select id_obed,nom_obed from obed order by 2
	end
	else if (@nom_tab='orient')
	begin
		select id_orient,nom_orient from orient order by 2
	end
	else if (@nom_tab='prs')
	begin
		select id_prs,concat(nom_prs,' ',prenom_prs) from prs where id_etat_prs in (select id_etat_prs from etat_prs where actif=1) order by 2;
	end
	else if (@nom_tab='prs_login')
	begin
		select id_prs,concat(nom_prs,' ',prenom_prs) from prs where id_etat_prs in (select id_etat_prs from etat_prs where actif=1) order by 2;
	end
	else if (@nom_tab='rite')
	begin
		select id_rite,nom_rite from rite order by 2;
	end
	else if (@nom_tab='temple')
	begin
		select id_temple,code_temple from temple order by 2;
	end
	else if (@nom_tab='terr')
	begin
		select id_terr,nom_terr from terr order by 2;
	end
	else if (@nom_tab='type_doc')
	begin
		select id_type_doc,nom_type_doc from type_doc order by 2;
	end
	else if (@nom_tab='type_fic')
	begin
		select id_type_fic,type_fic from type_fic order by 2;
	end
	else if (@nom_tab='type_loge')
	begin
		select id_type_loge,lib_type_loge from type_loge order by 2;
	end
	else if (@nom_tab='type_off')
	begin
		select id_type_off,type_off from type_off order by num_off;
	end
	else if (@nom_tab='type_tenue')
	begin
		select id_type_tenue,type_tenue from type_tenue order by 2;
	end
	else if (@nom_tab='ville')
	begin
		select id_ville,nom_ville from ville order by 2;
	end
end
go
alter procedure AZinit_cbo_bis @nom_tab varchar(200),@id int
as
begin
	if(@nom_tab='loge_tenue_deb')
	begin
		select t.id_loge_tenue,concat(t.date_tenue,isnull(concat(' (',c.nom_cerem,')'),''))
		from loge_tenue t
		left outer join cerem c on t.id_cerem=c.id_cerem
		where t.id_loge=@id order by 2;
	end
	else if(@nom_tab='loge_tenue_fin')
	begin
		select t.id_loge_tenue,concat(t.date_tenue,isnull(concat(' (',c.nom_cerem,')'),''))
		from loge_tenue t
		inner join loge_tenue td on td.id_loge_tenue=@id and t.id_loge=td.id_loge and t.date_tenue>td.date_tenue
		left outer join cerem c on t.id_cerem=c.id_cerem
		order by 2;
	end;
end
