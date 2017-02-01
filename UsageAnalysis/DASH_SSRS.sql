use ReportServer
 
DECLARE @StartDate DATETIME = '2016/10/01' 
DECLARE @EndDate DATETIME = '2016/12/31' 

SELECT

 cat.path 'Report_Name'
 ,ex.UserName UserId
 , count(1) [rowcount]
FROM ExecutionLog AS ex 
INNER JOIN Catalog AS cat ON ex.ReportID = cat.ItemID 
WHERE ex.UserName NOT IN (
						--System Accounts
						'VCH\SPDBDECSUP05svc'
						,'VRHB\V0042491'

						--CoOp						
						,'vch\jhu12'
						,'vch\lzeleschuk'

						--DMR
						,'vch\achung3'
						,'vch\aknox'
						,'vch\vaggarwal'
						,'vch\kluers'
						,'vch\mchase2'
						,'vch\mchase'
						,'vch\thearty2'
						,'vch\pchung2'
						,'vch\eyoung'

						--Acute
						,'vch\aprocter'
						,'vch\rdong'
						,'vch\ssirett'
						,'vch\jsun5'
						,'vch\wcheng2'
						,'vch\sdhaliwa'
						,'Vch\jtiang'

						--CST
						,'vch\cdaoust2'
						,'vch\sjiwa'
						,'vch\mradu'
						,'vrhb\lle'
						,'vch\dsandhu6'
						,'vch\NJamal'
						

						--Community
						,'vch\gcrowell' 
						,'vch\llum5'
						,'vch\achen5'
						,'vch\mchuong'
						,'vch\useetharaman'
						,'vch\rlee10'
						,'vch\dli4'
						,'vch\gtaghizadeh'
						,'vch\nnosseir'
						,'vch\sroberts5'
						,'vch\pdimarco2'
						,'vch\dcampbell2'
						,'Vch\egladstone'

						--SI
						,'VCH\cinigo'
						,'Vch\JChan20'
						,'vch\mli9'
						,'vch\mjohnson2'
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
						,'vch\stchow'
						,'vch\ewu4'
						,'vch\ddong'
						,'vch\rmartinez3'
						,'vch\jluo2'
						,'vch\yliu5'
						,'vch\lkawazoe'
						,'vch\cswindellsnader'

						--PPE
						,'vch\cfung5'
						,'vch\vzhou'
						,'vch\pfennell'
						,'vch\czhang9'
						,'vch\AHay2'
						,'vch\nli3'

						-- Admins
						,'vch\vguerrero'
						,'vch\jsheppard'

						-- Other
						
						,'vch\FLi3'
						,'vch\cmah'
						,'vch\kredfern2'
						,'vch\vzhou'
						,'vch\jwright3'
						,'vch\wcheng2'
						,'vch\yliu5'
						,'vch\zkurzawa'
						,'vch\ang8'
						,'vch\elai3'
						,'vch\cporras2'
						,'vch\clagbao'
	)
	AND ex.TimeStart BETWEEN @StartDate AND @EndDate
	Group by cat.path, ex.UserName
ORDER BY cat.path,  [rowcount] desc, ex.UserName
