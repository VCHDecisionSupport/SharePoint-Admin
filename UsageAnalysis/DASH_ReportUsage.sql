USE [DSSPPROD_UsageAndHealth] 

go 

DECLARE @StartDate DATETIME = '2016/10/01' 
DECLARE @EndDate DATETIME = '2016/12/31' 

DROP TABLE #tempdata 

SELECT * 
INTO   #tempdata 
FROM   (SELECT CONVERT(VARCHAR(10), [logtime], 111)        AccessDate, 
               Substring([userlogin], 8, Len([userlogin])) UserId, 
               [url] 
        FROM   [dbo].[fileusage] 
        WHERE 
         --Exclude DS UserIds and SP Installation Accounts 
         userlogin NOT IN ( 
                          --System Accounts 
                          'HEALTHBC\svc_ds_sp_install', '', 
                          'healthbc\svc_ds_sp_farm', 
                          'nt authority\iusr' 
                          , 
                          'i:0#.w|healthbc\svc_ds_sp_install', 
                          'i:0#.w|healthbc\svc_ds_sp_crawl', 
                          'i:0#.w|healthbc\svc_ds_sp_webapp', 
                          'i:0#.w|healthbc\svc_ds_sp_farm', 
                          'i:0#.w|vch\svcdswebtstsql' 
                          -- Admins 
                          , 'i:0#.w|vch\vguerrero', 'i:0#.w|vch\jsheppard', 
                          'i:0#.w|vch\GCrowell_SA' 
                          --CoOp 
                          , 
                          'i:0#.w|vch\jhu12', 'i:0#.w|vch\lzeleschuk' 
                          --DMR 
                          , 'i:0#.w|vch\achung3', 'i:0#.w|vch\aknox', 
                          'i:0#.w|vch\vaggarwal', 'i:0#.w|vch\kluers', 
                          'i:0#.w|vch\mchase2', 
                          'i:0#.w|vch\mchase', 
                          'i:0#.w|vch\thearty2', 'i:0#.w|vch\pchung2', 
                          'i:0#.w|vch\eyoung' 
                          --Acute 
                          , 'i:0#.w|vch\aproctor', 
                          'i:0#.w|vch\rdong', 'i:0#.w|vch\ssirett', 
                          'i:0#.w|vch\jsun5', 
                          'i:0#.w|vch\wcheng2', 
                          'i:0#.w|vch\sdhaliwa', 'i:0#.w|vch\jtiang' 
                          --CST 
                          , 'i:0#.w|vch\cdaoust2', 'i:0#.w|vch\sjiwa', 
                          'i:0#.w|vch\mradu', 'i:0#.w|vrhb\lle', 
                          'i:0#.w|vch\dsandhu6', 
                          'i:0#.w|vch\NJamal' 
                          --Community 
                          , 
                          'i:0#.w|vch\gcrowell', 'i:0#.w|vch\llum5', 
                          'i:0#.w|vch\achen5', 
                          'i:0#.w|vch\mchuong', 
                          'i:0#.w|vch\useetharaman', 'i:0#.w|vch\rlee10', 
                          'i:0#.w|vch\dli4', 
                          'i:0#.w|vch\gtaghizadeh', 
                          'i:0#.w|vch\nnosseir', 'i:0#.w|vch\sroberts5', 
                          'i:0#.w|vch\pdimarco2', 
                          'i:0#.w|vch\dcampbell2', 
                          'i:0#.w|vch\egladstone' 
                          --SI 
                          , 'i:0#.w|vch\JChan20', 'i:0#.w|vch\mli9', 
                          'i:0#.w|vch\mjohnson2', 
                          'i:0#.w|vch\llim', 'i:0#.w|vch\cferguson2', 
                          'i:0#.w|vch\ciningo', 
                          'i:0#.w|vch\ayuen', 
                          'i:0#.w|vch\ryao3', 'i:0#.w|vch\snanji', 
                          'i:0#.w|vch\mli11', 
                          'i:0#.w|vch\sgani2' 
                          , 
                          'i:0#.w|vch\haisake', 'i:0#.w|vch\pkaloupi', 
                          'i:0#.w|vch\mjohnson2', 
                          'i:0#.w|vch\sstrandb', 
                          'i:0#.w|vch\stchow', 'i:0#.w|vch\lkawazoe', 
                          'i:0#.w|vch\lobrien', 
                          'i:0#.w|vch\rsu', 
                          'i:0#.w|vch\mluk3', 'i:0#.w|vrhb\khawkins', 
                          'i:0#.w|vrhb\stwong', 
                          'i:0#.w|vch\stchow', 
                          'i:0#.w|vch\ewu4', 'i:0#.w|vch\ddong', 
                          'i:0#.w|vch\rmartinez3', 
                          'i:0#.w|vch\jluo2', 
                          'i:0#.w|vch\yliu5', 'i:0#.w|vch\lkawazoe', 
                          'i:0#.w|vch\cswindellsnader' 
                          --PPE 
                          , 'i:0#.w|vch\cfung5', 
                          'i:0#.w|vch\vzhou', 'i:0#.w|vch\pfennell', 
                          'i:0#.w|vch\czhang9' 
                          , 
                          'i:0#.w|vch\AHay2', 
                          'i:0#.w|vch\nli3' 
                          -- Other 
                          , 'i:0#.w|vch\FLi3', 'i:0#.w|vch\cmah', 
                          'i:0#.w|vch\kredfern2', 
                          'i:0#.w|vch\vzhou', 'i:0#.w|vch\jwright3', 
                          'i:0#.w|vch\wcheng2' 
                          , 
                          'i:0#.w|vch\yliu5', 
                          'i:0#.w|vch\zkurzawa', 'i:0#.w|vch\ang8', 
                          'i:0#.w|vch\elai3', 
                          'i:0#.w|vch\cporras2', 'i:0#.w|vch\clagbao' ) 
         AND [logtime] BETWEEN @StartDate AND @EndDate) t 

SELECT * 
FROM   #tempdata 