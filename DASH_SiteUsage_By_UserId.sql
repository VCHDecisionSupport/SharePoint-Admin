USE [DSSPPROD_UsageAndHealth]
GO
Declare @StartDate DateTime = '2016/10/24'
Declare @EndDate DateTime = '2016/11/07'

IF OBJECT_ID('tempdb.dbo.#tempData', 'U') IS NOT NULL
drop table  #tempData

SELECT * 
INTO   #tempdata 
FROM   (SELECT DISTINCT CONVERT(VARCHAR(10), [logtime], 111)        AccessDate, 
                        Substring([userlogin], 8, Len([userlogin])) [UserLogin], 
                        SiteURL 
        FROM   [dbo].[featureusage] 
        WHERE 
         --Only DASH Stats 
         siteurl LIKE'%https://vchphcdash.healthbc.org%' 
         AND siteurl NOT IN ( 
                            --Exclude HomePage 
                            'https://vchphcdash.healthbc.org/Pages/DASH.aspx' 
                            --Exclude Request Submission Page 
                            ,  'https://vchphcdash.healthbc.org/Pages/RequestSubmitted.aspx' 
							, 'https://vchphcdash.healthbc.org/PublishingImages/Forms/Thumbnails.aspx')) t 

SELECT  userlogin, Count(1) #Visits
FROM   #tempdata 
WHERE  userlogin NOT IN( 
                       --System Accounts
						'healthbc\svc_ds_sp_install'
						,'healthbc\svc_ds_sp_crawl' 

						--CoOp
						,'vch\jhu12'

						--DMR
						,'vch\achung3'
						,'vch\aknox'
						,'vch\vaggarwal'
						,'vch\kluers'
						,'vch\vguerrero'
						,'vch\mchase2'
						,'vch\mchase'
						,'vch\thearty2'

						--Acute
						,'vch\aproctor'
						,'vch\rdong'
						,'vch\ssirett'

						--CST
						,'vch\cdaoust2'
						,'vch\sjiwa'
						,'vch\mradu'
						,'vrhb\lle'
						,'vch\dsandhu6'

						--Community
						,'vch\gcrowell' 
						,'vch\therart2'
						,'vch\llum5'
						,'vch\achen5'
						,'vch\mchuong'
						,'vch\useetharaman'
						,'vch\rlee10'
						,'vch\dli4'
						,'vch\gtaghizadeh'
						,'vch\nnosseir'
						,'vch\sroberts5'

						--SI
						,'vch\mli9'
						,'vch\llim'
						,'vch\cferguson2'
						,'vch\ciningo'
						,'vch\ayuen'
						,'vch\ryao3'
						,'vch\snanji'
						,'vch\mli11'
						,'vch\sgani2'
						,'vch\haisake'
						,'vch\pkaloupi'
						,'vch\mjohnson2'
						,'vch\sstrandb'
						,'vch\stchow'
						,'vch\lkawazoe'
						,'vch\lobrien'
						,'vch\rsu'
						,'vch\mluk3'
						,'vrhb\khawkins'
						,'vrhb\stwong'

						--PPE
						,'vch\cfung5'

						-- Other
						,'vch\kredfern2'
						,'vch\vzhou'
						,'vch\jwright3'
						,'vch\wcheng2'
						,'vch\yliu5'
						,'vch\zkurzawa'
						,'vch\ang8'
) 
and AccessDate between @StartDate and @EndDate
Group by  userlogin
ORDER  BY #Visits desc, userlogin

go 