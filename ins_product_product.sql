INSERT INTO public.product (manufacturer_id,cat_sub_assoc_id,product_model_number,product_hash,type,name,base_name,upc,depth,height,width,diameter,shipping_weight,tax_code,freight_class,freight_code,description,msrp,map,utility_info,sku,product_family,lead_time,price_by_qty,variant_group,option_flag,created_at,created_by,updated_at,updated_by,deleted_at,deleted_by)
SELECT a.mfg_id,a.atero_cat_id,a.model_no,a.product_hash,'Product',a.name,NULL,NULL,a.length,a.height,a.width,NULL,a.shipping_weight,a.avalara_tax_code,a.freight_class,a.avalara_freight_code,a.key_features,a.price_usd,NULL,a.key_utility_information,a.sku,UPPER(a.product_family),a.lead_time,a.price_by_qty,a.groups,a.option_flag,current_timestamp,1,NULL,NULL,NULL,NULL
FROM loading.akeneo a
WHERE a.item_type = 'item_type_product'
ON CONFLICT (product_hash) DO UPDATE
SET cat_sub_assoc_id=EXCLUDED.cat_sub_assoc_id,product_hash=EXCLUDED.product_hash,type='Product',name=EXCLUDED.name,depth=EXCLUDED.depth,height=EXCLUDED.height,width=EXCLUDED.width,shipping_weight=EXCLUDED.shipping_weight,tax_code=EXCLUDED.tax_code,freight_class=EXCLUDED.freight_class,freight_code=EXCLUDED.freight_code,description=EXCLUDED.description,msrp=EXCLUDED.msrp,map=EXCLUDED.map,utility_info=EXCLUDED.utility_info,sku=EXCLUDED.sku,product_family=EXCLUDED.product_family,lead_time=EXCLUDED.lead_time,price_by_qty=EXCLUDED.price_by_qty,variant_group=EXCLUDED.variant_group,option_flag=EXCLUDED.option_flag,updated_at=current_timestamp,updated_by=1;
INSERT INTO public.product (manufacturer_id,cat_sub_assoc_id,product_model_number,product_hash,type,name,base_name,upc,depth,height,width,diameter,shipping_weight,tax_code,freight_class,freight_code,description,msrp,map,utility_info,sku,product_family,lead_time,price_by_qty,variant_group,option_flag,created_at,created_by,updated_at,updated_by,deleted_at,deleted_by)
SELECT a.mfg_id,a.atero_cat_id,a.model_no,a.product_hash,'Accessory',a.name,NULL,NULL,a.length,a.height,a.width,NULL,a.shipping_weight,a.avalara_tax_code,a.freight_class,a.avalara_freight_code,a.key_features,a.price_usd,NULL,a.key_utility_information,a.sku,UPPER(a.product_family),a.lead_time,a.price_by_qty,a.groups,a.option_flag,current_timestamp,1,NULL,NULL,NULL,NULL
FROM loading.akeneo a
WHERE a.item_type = 'item_type_accessory'
ON CONFLICT (product_hash) DO UPDATE
SET cat_sub_assoc_id=EXCLUDED.cat_sub_assoc_id,product_hash=EXCLUDED.product_hash,type='Accessory',name=EXCLUDED.name,depth=EXCLUDED.depth,height=EXCLUDED.height,width=EXCLUDED.width,shipping_weight=EXCLUDED.shipping_weight,tax_code=EXCLUDED.tax_code,freight_class=EXCLUDED.freight_class,freight_code=EXCLUDED.freight_code,description=EXCLUDED.description,msrp=EXCLUDED.msrp,map=EXCLUDED.map,utility_info=EXCLUDED.utility_info,sku=EXCLUDED.sku,product_family=EXCLUDED.product_family,lead_time=EXCLUDED.lead_time,price_by_qty=EXCLUDED.price_by_qty,variant_group=EXCLUDED.variant_group,option_flag=EXCLUDED.option_flag,updated_at=current_timestamp,updated_by=1;
