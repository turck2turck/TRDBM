INSERT INTO public.product (manufacturer_id,cat_sub_assoc_id,product_model_number,product_hash,type,name,base_name,upc,depth,height,width,diameter,shipping_weight,tax_code,freight_class,freight_code,description,msrp,map,utility_info,sku,product_family,lead_time,variant_group,option_flag,created_at,created_by,updated_at,updated_by,deleted_at,deleted_by)
SELECT a.mfg_id,a.atero_cat_id,a.model_no,a.product_hash,'Product',a.name,NULL,NULL,a.post_depth,a.height,a.width,NULL,a.post_shipping_weight,a.avalara_tax_code,a.freight_class,a.avalara_freight_code,a.key_features,a.post_msrp,NULL,a.key_utility_information,a.sku,UPPER(a.product_family),a.lead_time,a.groups,a.option_flag,current_timestamp,1,NULL,NULL,NULL,NULL
FROM loading.akeneo a
<<<<<<< HEAD
WHERE a.item_type = 'item_type_product' and epn_option_products IS NULL 
ON CONFLICT (product_hash) DO UPDATE
SET cat_sub_assoc_id=EXCLUDED.cat_sub_assoc_id,product_hash=EXCLUDED.product_hash,type='Product',name=EXCLUDED.name,depth=EXCLUDED.depth,height=EXCLUDED.height,width=EXCLUDED.width,shipping_weight=EXCLUDED.shipping_weight,unit_of_measure=EXCLUDED.unit_of_measure,uom_measurement=EXCLUDED.uom_measurement,tax_code=EXCLUDED.tax_code,freight_class=EXCLUDED.freight_class,freight_code=EXCLUDED.freight_code,description=EXCLUDED.description,msrp=EXCLUDED.msrp,map=EXCLUDED.map,utility_info=EXCLUDED.utility_info,sku=EXCLUDED.sku,product_family=EXCLUDED.product_family,lead_time=EXCLUDED.lead_time,variant_group=EXCLUDED.variant_group,updated_at=current_timestamp,updated_by=1,deleted_at=NULL,deleted_by=NULL;

INSERT INTO public.product (manufacturer_id,cat_sub_assoc_id,product_model_number,product_hash,type,name,base_name,upc,depth,height,width,diameter,shipping_weight,unit_of_measure,uom_measurement,tax_code,freight_class,freight_code,description,msrp,map,utility_info,sku,product_family,lead_time,variant_group,option_flag,created_at,created_by,updated_at,updated_by,deleted_at,deleted_by)
SELECT a.mfg_id,a.atero_cat_id,a.model_no,a.product_hash,'Product',a.name,NULL,NULL,a.post_depth,a.height,a.width,NULL,a.post_shipping_weight,a.selling_unit,a.uom_measurement,a.avalara_tax_code,a.freight_class,a.avalara_freight_code,a.key_features,a.post_msrp,NULL,a.key_utility_information,a.sku,UPPER(a.product_family),a.lead_time,a.groups,'1',current_timestamp,1,NULL,NULL,NULL,NULL
FROM loading.akeneo a
WHERE a.item_type = 'item_type_product' and epn_option_products IS NOT NULL
ON CONFLICT (product_hash) DO UPDATE
SET cat_sub_assoc_id=EXCLUDED.cat_sub_assoc_id,product_hash=EXCLUDED.product_hash,type='Product',name=EXCLUDED.name,depth=EXCLUDED.depth,height=EXCLUDED.height,width=EXCLUDED.width,shipping_weight=EXCLUDED.shipping_weight,unit_of_measure=EXCLUDED.unit_of_measure,uom_measurement=EXCLUDED.uom_measurement,tax_code=EXCLUDED.tax_code,freight_class=EXCLUDED.freight_class,freight_code=EXCLUDED.freight_code,description=EXCLUDED.description,msrp=EXCLUDED.msrp,map=EXCLUDED.map,utility_info=EXCLUDED.utility_info,sku=EXCLUDED.sku,product_family=EXCLUDED.product_family,lead_time=EXCLUDED.lead_time,variant_group=EXCLUDED.variant_group,updated_at=current_timestamp,updated_by=1,deleted_at=NULL,deleted_by=NULL;

=======
WHERE a.item_type = 'item_type_product' 
ON CONFLICT (product_hash) DO UPDATE 
SET cat_sub_assoc_id=EXCLUDED.cat_sub_assoc_id,product_hash=EXCLUDED.product_hash,type='Product',name=EXCLUDED.name,depth=EXCLUDED.depth,height=EXCLUDED.height,width=EXCLUDED.width,shipping_weight=EXCLUDED.shipping_weight,tax_code=EXCLUDED.tax_code,freight_class=EXCLUDED.freight_class,freight_code=EXCLUDED.freight_code,description=EXCLUDED.description,msrp=EXCLUDED.msrp,map=EXCLUDED.map,utility_info=EXCLUDED.utility_info,sku=EXCLUDED.sku,product_family=EXCLUDED.product_family,lead_time=EXCLUDED.lead_time,variant_group=EXCLUDED.variant_group,option_flag=EXCLUDED.option_flag,updated_at=current_timestamp,updated_by=1;
>>>>>>> 2bf7a72d38b355222031dbbc9e93e7587d0ab957
