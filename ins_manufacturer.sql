INSERT INTO public.manufacturer (mfr_abbr,short_name,name,logo,message,created_at,created_by)
<<<<<<< HEAD
SELECT mfr_abbr,mfr_short_name,mfr_long_name,mfr_logo,mfr_msg,current_timestamp,'1'
FROM loading.manufacturer_address
WHERE 1=1
ON CONFLICT(mfr_abbr) DO UPDATE
SET short_name=EXCLUDED.short_name,name=EXCLUDED.name,logo=EXCLUDED.logo,message=EXCLUDED.message,updated_at=current_timestamp,updated_by='1';
=======
SELECT mfr_abbr,mfr_short_name,mfr_long_name,mfr_logo,mfr_msg,current_timestamp,1
FROM loading.manufacturer_address
ON CONFLICT (mfr_abbr) DO UPDATE
SET mfr_abbr=EXCLUDED.mfr_abbr,short_name=EXCLUDED.short_name,name=EXCLUDED.name,logo=EXCLUDED.logo,message=EXCLUDED.message,updated_at=current_timestamp, updated_by=1;
>>>>>>> 2bf7a72d38b355222031dbbc9e93e7587d0ab957