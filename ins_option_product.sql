INSERT INTO public.option_product (product_model_number,product_hash,name,base_name,upc,depth,height,width,diameter,shipping_weight,tax_code,freight_class,freight_code,description,msrp,map,utility_info,sku,product_family,lead_time,created_at,created_by,updated_at,updated_by,deleted_at,deleted_by)
SELECT a.model_no,a.product_hash,a.name,NULL,NULL,a.post_depth,a.height,a.width,NULL,a.post_shipping_weight,a.avalara_tax_code,a.freight_class,a.avalara_freight_code,a.key_features,a.post_msrp,NULL,a.key_utility_information,a.sku,UPPER(a.product_family),a.lead_time,current_timestamp,1,NULL,NULL,NULL,NULL
FROM loading.akeneo a
WHERE a.item_type = 'item_type_option' 
ON CONFLICT (product_hash) DO UPDATE
<<<<<<< HEAD
SET name=EXCLUDED.name,base_name=EXCLUDED.base_name,groups=EXCLUDED.groups,depth=EXCLUDED.depth,height=EXCLUDED.height,width=EXCLUDED.width,shipping_weight=EXCLUDED.shipping_weight,unit_of_measure=EXCLUDED.unit_of_measure,uom_measurement=EXCLUDED.uom_measurement,tax_code=EXCLUDED.tax_code,freight_class=EXCLUDED.freight_class,freight_code=EXCLUDED.freight_code,description=EXCLUDED.description,msrp=EXCLUDED.msrp,utility_info=EXCLUDED.utility_info,sku=EXCLUDED.sku,product_family=EXCLUDED.product_family,lead_time=EXCLUDED.lead_time,updated_at=current_timestamp,updated_by=1,deleted_at=NULL,deleted_by=NULL;

=======
SET name=EXCLUDED.name,depth=EXCLUDED.depth,height=EXCLUDED.height,width=EXCLUDED.width,shipping_weight=EXCLUDED.shipping_weight,tax_code=EXCLUDED.tax_code,freight_class=EXCLUDED.freight_class,freight_code=EXCLUDED.freight_code,description=EXCLUDED.description,msrp=EXCLUDED.msrp,utility_info=EXCLUDED.utility_info,sku=EXCLUDED.sku,product_family=EXCLUDED.product_family,lead_time=EXCLUDED.lead_time,updated_at=current_timestamp,updated_by=1;
>>>>>>> 2bf7a72d38b355222031dbbc9e93e7587d0ab957
